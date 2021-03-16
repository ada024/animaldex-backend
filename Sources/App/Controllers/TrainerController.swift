import Foundation
import Vapor

final class TrainerController {
    
    func all(_ req: Request) throws -> EventLoopFuture<[Trainer]> {
        Trainer.query(on: req.db).with(\.$animals).all()
      //  Trainer.query(on: req.db).with(\.$act).with(\.$ranimals).all()
    }
    

}
