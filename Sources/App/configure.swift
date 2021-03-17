import Vapor
import Fluent
import Leaf
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    switch app.environment {
    case .production:
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST")!,
            username: Environment.get("DATABASE_USERNAME")!,
            password: Environment.get("SECRET_KEY")!.base64Decoded()!,
            database:  Environment.get("DATABASE")
        ), as: .psql)
    default:
        app.databases.use(.postgres(
            hostname:  "localhost",
            username:  "postgres",
            password:  "",
            database:  "animaldexdevdb"
        ), as: .psql)
    }
    app.migrations.add(CreateTrainer())
    app.migrations.add(CreateAnimal())
   
    app.views.use(.leaf)
    try routes(app)
}
