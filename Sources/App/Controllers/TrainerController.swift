import Foundation
import Vapor

final class TrainerController {
    
    func all(_ req: Request) throws -> EventLoopFuture<[Trainer]> {
        Trainer.query(on: req.db).with(\.$animals).all()
    }
    // Can include as many as needed
    func allwassociation(_ req: Request) throws -> EventLoopFuture<[Trainer]> {
          Trainer.query(on: req.db).with(\.$items).with(\.$animals).all()
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Trainer> {
       let user = try req.content.decode(Trainer.self)
        return user.create(on: req.db).map { user}
    }
    
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Trainer.find(req.parameters.get("userId"), on: req.db).unwrap(or: Abort(.notFound))
            .flatMap{
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
    // Create trainer with item
    app.post("trainer", "api", ":trainerId", "item",":itemId") { req ->EventLoopFuture<HTTPStatus> in
              let trainer = Trainer.find(req.parameters.get("trainerId"), on: req.db).unwrap(or: Abort(.notFound))

              let item = Item.find(req.parameters.get("itemId"), on: req.db).unwrap(or: Abort(.notFound))
              
              return trainer.and(item).flatMap { (trainer, item) in trainer.$items.attach(item, on: req.db)
              }.transform(to: .ok)
          }
    

}
