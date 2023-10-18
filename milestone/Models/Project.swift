//
//  ProjectModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI

extension Array<Tag> {
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
}

struct Project:Identifiable, Codable {
    var id: UUID = UUID()
    var name:String
    var update:Date
    var create:Date
    var icon: String
    var iconColor: Color
    var tags: [Tag] = []
    var timeLines:[TimeLine] = []
    
    init(id:UUID? ,name: String, update: Date = Date(), create: Date = Date(), icon: String, iconColor: Color, tags: [Tag] = [], timeLines: [TimeLine] = []) {
        self.id = id ?? UUID()
        self.name = name
        self.update = update
        self.icon = icon
        self.iconColor = iconColor
        self.tags = tags
        self.timeLines = timeLines
        self.create = create
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.update = try container.decode(Date.self, forKey: .update)
        self.create = try container.decode(Date.self, forKey: .create)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.iconColor = try container.decode(Color.self, forKey: .iconColor)
        self.tags = try container.decode([Tag].self, forKey: .tags)
        self.timeLines = try container.decode([TimeLine].self, forKey: .timeLines)
    }
    
    static func rebuildTags(tags:String) throws ->[Tag]{
        let data:Data = tags.data(using: .utf8)!
        return try JSONDecoder().decode([Tag].self, from: data)
    }

    
    init(entity:ProjectEntity){
        self.id = entity.id!
        self.name = entity.name!
        self.update = entity.update!
        self.create = entity.create!
        self.icon = entity.icon!
        self.iconColor = Color(hex: entity.iconColor!)
        
        do {
            self.tags = try Project.rebuildTags(tags: entity.tags!)
        } catch  {
            self.tags = []
        }
        self.timeLines = []
    }
    
    static func rebuildProjects(entitys:[ProjectEntity])->[Project]{
        return entitys.map({Self(entity: $0)})
    }
    
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case update
        case create
        case icon
        case iconColor
        case tags
        case timeLines
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.update, forKey: .update)
        try container.encode(self.icon, forKey: .icon)
        try container.encode(self.iconColor, forKey: .iconColor)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.timeLines, forKey: .timeLines)
    }
    
    
    static func getNew()->Project{
        return Project(id:nil, name: "", icon: "📖", iconColor: Color("GreenColor"))
    }
    
}
