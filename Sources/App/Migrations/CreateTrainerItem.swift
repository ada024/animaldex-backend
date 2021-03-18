
import Foundation
import Fluent
import FluentPostgresDriver

struct CreateTrainerItem: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("trainer_items")
            .id()
            .field("trainer_id", .uuid, .required, .references("trainers", "id"))
            .field("item_id", .uuid, .required, .references("items", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("trainer_items").delete()
    }
    
}
