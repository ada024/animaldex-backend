

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class TrainerItem: Model {
    
    static let schema = "trainer_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "trainer_id")
    var trainer: Trainer
    
    @Parent(key: "item_id")
    var item: Item
    
    init() { }
    
    init(trainerId: UUID, itemId: UUID) {
        self.$trainer.id = trainerId
        self.$item.id = itemId
    }
    
}

