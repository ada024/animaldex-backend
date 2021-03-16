import Foundation
import Vapor

final class TrainerController {
    
    func all(_ req: Request) throws -> EventLoopFuture<[Trainer]> {
        //  Trainer.query(on: req.db).with(\.$act).with(\.$ranimals).all()
        Trainer.query(on: req.db).with(\.$animals).all()
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
    

}
