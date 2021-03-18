

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Item: Model, Content {
    
    static let schema = "items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String
    
    @Siblings(through: TrainerItem.self, from: \.$item, to: \.$trainer)
    var trainers: [Trainer]
    
    init() {}
    
    init(id: UUID? = nil, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    
}
