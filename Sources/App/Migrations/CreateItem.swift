import Foundation
import Fluent
import FluentPostgresDriver

struct CreateItem: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("items")
        .id()
        .field("name", .string)
        .field("image", .string)
        .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("items").delete()
    }
    
}
