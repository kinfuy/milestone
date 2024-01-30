//
//  TimeLineModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI
import CoreData






struct TimeLine:Identifiable, Codable {
    var id: UUID
    var name:String
    var icon: Icon
    var nodes: [LineNode] = []
    var milestone:[Milestone] = []
    var create:Date
    var update:Date
    
    var isEdit = false
    
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
        let t = TimeLine(
            id: timeLine.id!,
            name: timeLine.name!,
            icon: Icon(emoji: timeLine.icon!),
            nodes: [],
            create: timeLine.create ?? Date(),
            update: timeLine.update ?? Date()
        )
        return t
    }
    
    func gapNode(nodeId:UUID,order:SortOption? = .asc)->Bool{
        if let idx = nodes.firstIndex(where: {$0.id == nodeId}) {
            if(order == .asc){
                if(idx == 0) {
                    return true
                }
                if(idx == nodes.count) {
                    return true
                }
                if(idx-1 > 0){
                    return nodes[idx-1].create.day() != nodes[idx].create.day()
                }
            }
            else {
                if(idx == nodes.count - 1){
                    return true
                }
                if(idx+1 < nodes.count){
                    return nodes[idx+1].create.day() != nodes[idx].create.day()
                }
                
            }
            
        }
        return false
    }
    
    mutating func setOrder(order:SortOption){
        if(order == .asc){
            self.nodes.sort(by: {$0.create < $1.create})
        }else{
            self.nodes.sort(by: {$0.create > $1.create})
        }
       
    }
}
