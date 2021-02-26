
import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

struct CreateAnimal: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("animals")
            .id()
            .field("name", .string, .required)
            .field("isSelected", .bool)
            .field("image", .string)
            .field("type", .string, .required)
            .field("description", .string, .required)
            .field("user_id", .uuid, .references("users", "id")) // animals-table user_id =FK, ref user-table id=PK
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("animals").delete()
    }
}
