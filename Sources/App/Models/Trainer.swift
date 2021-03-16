import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Trainer: Model, Content {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
  
    @Children(for: \.$trainer)
    var animals: [Animal]
 
    @Siblings(through: UserItem.self, from: \.$trainer, to: \.$item)
    var items: [Item]
    
    
    init() {}
    
    init(id: UUID? = nil, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
