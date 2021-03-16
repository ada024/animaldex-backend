import Vapor
import Foundation



func routes(_ app: Application) throws {
    let trainerController = TrainerController()
    let animalsController = AnimalsController()
    let itemController = ItemController()
    app.get("trainers", "api", use: trainerController.all)
    app.get("trainerswassociation", "api", use: trainerController.allwassociation)
    app.post("api","trainers", ":trainerId", "item",":itemId", use: trainerController.createWithItem)
    app.post("trainers", "api", use: trainerController.create)
    app.delete("trainers","api",":userId", use: trainerController.delete)
    app.get("trainers","api",":trainerId", "animals" , use: animalsController.getByTrainerId)
    app.post("animals", use: animalsController.create)
    app.post("items", use: itemController.create)
    app.get("items", use: itemController.getItemsWithTrainer)
    
    
    //  localhost:8080 Leafindex-page
    app.get { req -> EventLoopFuture<View> in
        let homeContext =   Context(title: "Home",trainers: [])
        return  req.view.render("index", homeContext)
    }
    
    app.get("owneradd") { req  ->  EventLoopFuture<View> in
        let addContext =   Context(title: "Add Trainer",trainers: [])
        return  req.view.render("ownerAdd",addContext)
    }
    
  
    //    GET all trainers
    app.get("trainers") { req  in
        return  Trainer.query(on: req.db).with(\.$animals).all().flatMap( { trainers  -> EventLoopFuture<View> in
        let trainersContext =   Context(title: "Trainers", trainers: trainers)
                           return  req.view.render("trainers", trainersContext)
        })
    }
    
    
  
    app.get("trainers",":userId") { req -> EventLoopFuture<Trainer> in
        Trainer.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    //  Update
    app.put("trainers") { req -> EventLoopFuture<HTTPStatus> in
        let user = try req.content.decode(Trainer.self)
    
        return Trainer.find(user.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.name = user.name
            return $0.update(on: req.db).transform(to: .ok)
        }
    }
    

    app.delete("trainers", ":userId") { req -> EventLoopFuture<HTTPStatus> in
        Trainer.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
    
    

    app.post("trainers") { req -> EventLoopFuture<Response> in
        let user = try req.content.decode(Trainer.self) // content is body of the httprequest
        return user.create(on: req.db).map { user in
            req.redirect(to: "trainers")
        }
    }
    

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
      
        // /animals/DELETE
        app.post("animals", "delete",  ":animalId") { req -> EventLoopFuture<Response> in
            Animal.find(req.parameters.get("animalId"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap {
                    $0.delete(on: req.db)
                }.map { _ in
                 req.redirect(to: "/trainers")
                }
        }
    

    app.post("add-trainer") { req -> Response in
       let user = try req.content.decode(Trainer.self)
        print(user)
        return req.redirect(to: "/")
    }
}//


struct Context: Encodable {
    let title: String
    let trainers: [Trainer]
}
