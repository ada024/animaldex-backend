import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
    // hasMany - Relationship, animals
    @Children(for: \.$user)
    var animals: [Animal]
    
    init() {}
    
    init(id: UUID? = nil, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
