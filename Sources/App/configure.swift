import Vapor
import Fluent
import Leaf
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database:  "mydemodb"
    ), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateAnimal())
   
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
