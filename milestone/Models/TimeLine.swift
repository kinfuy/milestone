//
//  TimeLineModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI
import CoreData






struct TimeLine:Identifiable,Codable {
    var id: UUID
    var name:String
    var icon: Icon
    var nodes: [LineNode] = []
    var milestone:[Milestone] = []
    var create:Date
    var update:Date
    
    var isHasNodes:Bool {
        return !nodes.isEmpty
    }
    
    mutating func addNode(node:LineNode){
        self.nodes.append(node)
    }
    
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
    
    func into(context:NSManagedObjectContext)-> TimeLineEntity {
        let timeLine =  TimeLineEntity(context: context)
        timeLine.id = self.id
        timeLine.name = self.name
        return timeLine
    }
    
    static func from(timeLine: TimeLineEntity)-> TimeLine {
        let nodes = timeLine.nodes?.allObjects as! [NodeEntity]
        let t = TimeLine(
            id: timeLine.id!,
            name: timeLine.name!,
            icon: Icon(emoji: timeLine.icon!),
            nodes: nodes.map({LineNode.from(node:$0)}).sorted { $0.create < $1.create },
            create: timeLine.create ?? Date(),
            update: timeLine.update ?? Date()
        )
        return t
    }
}
