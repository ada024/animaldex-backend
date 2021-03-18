
import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

struct CreateTrainer: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
         database.schema("trainers")
            .id()
            .field("name", .string, .required)
            .field("image", .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
         database.schema("trainers").delete()
    }
}
