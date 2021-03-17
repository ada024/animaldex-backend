
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
            .field("trainer_id", .uuid, .references("trainers", "id")) // animals-table trainer_id =FK, ref trainer-table id=PK
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("animals").delete()
    }
}
