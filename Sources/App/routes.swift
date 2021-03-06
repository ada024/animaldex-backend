import Vapor
import Foundation



func routes(_ app: Application) throws {
    let trainerController = TrainerController()
    let animalsController = AnimalsController()
    let itemController = ItemController()
    app.get("api","trainers", use: trainerController.all)
    app.get("api","trainerswassociation", use: trainerController.allwassociation)
    app.post("api","trainers", ":trainerId", "item",":itemId", use: trainerController.createWithItem)
    app.post("api","trainers", use: trainerController.create)
    app.delete("api","trainers",":userId", use: trainerController.delete)
    app.get("api","trainers",":trainerId", "animals" , use: animalsController.getByTrainerId)
    app.post("api","animals", use: animalsController.create)
    app.post("api","items", use: itemController.create)
    app.get("api","items", use: itemController.getItemsWithTrainer)
    
    
    //  localhost:8080 Leafindex
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
            print("Trainers get called!!!!!!!!!!!!!!!!")
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
       // content is body of the httprequest
        let trainer = try req.content.decode(Trainer.self) //
        return trainer.create(on: req.db).map { trainer in
            req.redirect(to: "trainers")
        }
    }
    
// Maybe obsolete
    app.post("animals") { req -> EventLoopFuture<Response> in
        let animal = try req.content.decode(Animal.self)
        return animal.create(on: req.db).map { animal in
            req.redirect(to: "trainers")
        }
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
     _ = try req.content.decode(Trainer.self)
        return req.redirect(to: "/")
    }
}//


struct Context: Encodable {
    let title: String
    let trainers: [Trainer]
}
