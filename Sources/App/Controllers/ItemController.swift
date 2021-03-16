//  Created by Andreas M. (ada024) on 11/03/2021.

import Foundation

import Vapor

final class ItemController {
    
    func create(_ req: Request) throws -> EventLoopFuture<Item> {
       let item = try req.content.decode(Item.self)
        return item.create(on: req.db).map { item}
    }  
}
