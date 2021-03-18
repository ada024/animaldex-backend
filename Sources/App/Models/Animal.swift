import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Animal: Model, Content {
    
    static let schema = "animals"
    
    @ID(key: .id)
    var id: UUID? // PK
    
    @Field(key: "name")
    var name: String
   
    @Field(key: "image")
    var image: String?
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "isSelected")
    var isSelected: Bool
    
    @Field(key: "description")
    var description: String
    
    @Parent(key: "trainer_id") // FK
    var trainer: Trainer
    
    init() {}
    
    init(id: UUID? = nil, name: String, type: String, description: String, trainerId: UUID, image: String? = nil ) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.image = image
        self.$trainer.id = trainerId
    }
}
