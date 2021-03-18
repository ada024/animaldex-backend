
//
//  Created by Andreas M. (ada024) on 11/03/2021.
//

import Foundation
import Vapor
import Fluent

final class AnimalsController {
    
    func getByTrainerId(_ req: Request) throws -> EventLoopFuture<[Animal]> {
        guard let trainerId = req.parameters.get("trainerId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        return Animal.query(on: req.db).filter(\.$trainer.$id, .equal, trainerId).with(\.$trainer).all()
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Animal> {
          let animal = try req.content.decode(Animal.self)
          return animal.save(on: req.db).map { animal}
      }
}
