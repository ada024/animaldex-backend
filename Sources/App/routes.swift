import Vapor
import Foundation


struct Context1: Content {
    let users: [User1]
}

struct Animal1: Content {
    let name: String
    let type: String
    let description: String
}

struct User1: Content {
    
    var name: String
    var id: Int?
    var animals: [Animal1] = [Animal1]()
}


func routes(_ app: Application) throws {
    
    //  localhost:8080 Leafindex-page
    app.get { req -> EventLoopFuture<View> in
        let homeContext =   Context(title: "Home",users: [])
        return  req.view.render("index", homeContext)
    }
    
    
    
    app.get("owneradd") { req  ->  EventLoopFuture<View> in
        let addContext =   Context(title: "Add Trainer",users: [])
        return  req.view.render("ownerAdd",addContext)
    }
    
    
    
    //  localhost:8080/ trainers
    
    /*
    app.get("trainers") { req  ->  EventLoopFuture<View> in
        var user = User1(name: "Ash",id: 01)
        let animals = [Animal1(name: "Goldeen", type: "Water", description: "A water animal")]
        user.animals = animals
        
        var user2 = User1(name: "Misty",id: 02)
        let animals2 = [Animal1(name: "Goldeen", type: "Water", description: "A water animal"),Animal1(name: "Horsea", type: "Water", description: "Another water animal living in the sea ..........................................................")]
        user2.animals = animals2
        
        let context = Context1(users: [user,user2])
        return  req.view.render("trainers",context)
    }
    */

    // /users    GET all users
    app.get("trainers") { req  in
        return  User.query(on: req.db).with(\.$animals).all().flatMap( { users  -> EventLoopFuture<View> in
           // let users = userModels.isEmpty ? nil: userModels
        let trainersContext =   Context(title: "Trainers", users: users)
                           return  req.view.render("trainers", trainersContext)
        })
    }
    
    
    // user id
    app.get("trainers",":userId") { req -> EventLoopFuture<User> in
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // PUT = update
    app.put("trainers") { req -> EventLoopFuture<HTTPStatus> in
        let user = try req.content.decode(User.self)
    
        return User.find(user.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.name = user.name
            return $0.update(on: req.db).transform(to: .ok)
        }
    }
    
    // /user/id DELETE
    app.delete("trainers", ":userId") { req -> EventLoopFuture<HTTPStatus> in
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
    
    
    // trainers add POST
    app.post("trainers") { req -> EventLoopFuture<Response> in
        let user = try req.content.decode(User.self) // content is body of the httprequest
        return user.create(on: req.db).map { user in
            req.redirect(to: "trainers")
        }
    }
    
    // add Animal
    app.post("animals") { req -> EventLoopFuture<Animal> in
        let animal = try req.content.decode(Animal.self)
        return animal.create(on: req.db).map { animal }
        
    }
    
    // Update Animal
    app.post("animals", ":animalId", ":isSelected") { req -> EventLoopFuture<Response> in
     let val  = req.parameters.get("isSelected")
            
   
            
         return   Animal.find(req.parameters.get("animalId"), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            if  val!.lowercased() == "true" {
                        $0.isSelected = true
            }else if val!.lowercased() == "false" {
                        $0.isSelected  = false
                    }
            return $0.update(on: req.db)
            }.map {
            req.redirect(to: "/trainers")
            }
        
    }
      
        
        // /animals/id DELETE
        app.post("animals", "delete",  ":animalId") { req -> EventLoopFuture<Response> in
            Animal.find(req.parameters.get("animalId"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap {
                    $0.delete(on: req.db)
                }.map { _ in
                 req.redirect(to: "/trainers")
                }
        }
    
    // add user
    app.post("add-user") { req -> Response in
       let user = try req.content.decode(User.self)
        print(user)
        return req.redirect(to: "/")
    }
    
    
    /*
    func sampleEdit(_ req: Request) throws -> EventLoopFuture<Response> {
        let animal = try req.content.decode(Animal.self)
        let value = try req.content.decode(String.self)
        return User.find(animal.id, on: req.db).unwrap(or: Abort(.notFound)).map { in
            user.animals -> Response in
            if value.lowercased() == "true" {
                user.animals.updatedAnimal.isSelected = true
            } else if value.lowercased() == "false" {
             updatedAnimal.isSelected = false
            }
            
            return updatedAnimal.save(on: req)
                .map(to: Response.self) { savedAnimal in
                    guard savedAnimal.id != nil else {
                        throw Abort(.internalServerError)
                    }
                    return req.redirect(to: "/users/\(savedAnimal.user.parentID)")
        }
       }
    }
    */
    
    
    

    
    
}//


struct Context: Encodable {
    let title: String
    let users: [User]
}
