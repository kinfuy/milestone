//
//  LineNodeModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI
import CoreData

enum NodeType: String, Identifiable, CaseIterable, Codable{
    var id: RawValue {rawValue}
    case nagging = "nagging"
    case task = "task"
    case milestone = "milestone"
    case subscribe = "subscribe"
    case count = "count"
    case unowned = "unowned"
    
    
    
    var icon: SFSymbol {
        switch self {
        case .milestone:
            return SFSymbol.flag
        case .nagging:
            return SFSymbol.message
        case .task:
            return SFSymbol.clock
        case .count:
            return SFSymbol.calendar
        default:
            return SFSymbol.clock
        }
        
    }
    
    static var list:[NodeType] {
        return NodeType.allCases.filter({$0.rawValue != "unowned"})
    }
    
    var text: String {
        switch self {
        case .nagging:
            return "普通卡"
        case .task:
            return "任务卡"
        case .milestone:
            return "里程碑"
        case .subscribe:
            return "订阅卡"
        case .count:
            return "纪念卡"
        default:
            return "未知"
        }
    }
    
    var desc:String {
        switch self {
        case .milestone:
            return "记录一些关键节点"
        case .nagging:
            return "一个普通的节点"
        case .task:
            return "记录任务的节点"
        case .subscribe:
            return "记录订阅节点"
        case .count:
            return "记录一些重要日子"
            
        default:
            return "未知的新节点，去新版尝试吧"
        }
    }
}

enum NodeStatus: String, CaseIterable, Codable {
   
    case notStart = "未开始"
    case complete = "已完成"
    case progress = "进行中"
    case expire = "已过期"
    case unowned = "未知"
        
    var text: String {
        return self.rawValue
    }
    
    var canCompleted: Bool {
        return self != .complete && self != .expire
    }
}

struct LineNode:Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title:String
    var type: NodeType
    var create:Date
    var update:Date
    var content:String?
    var startTime:Date?
    var endTime:Date?
    var status:NodeStatus = .unowned
    
    var isEdit:Bool = false
    
    var belong:UUID?

    var diffEndTime:String?
    
    var holdTime:String?
    
    var needTip:Bool = false
    
    
    mutating func updateDiff(){
        if let end = self.endTime {
            let diff = DateClass.dateDifference(end, from: Date())
            if(diff > 0){
                self.diffEndTime =  "剩余\(Int32(diff.rounded()))天"
                if(diff < 3) {
                    self.needTip = true
                }
            }else{
                if(self.status != .complete){
                    self.status = .expire
                }
                
            }
        }
    }
    
    
    mutating func initStatus(){
        self.updateDiff()
    }
    
    func into(context:NSManagedObjectContext)->NodeEntity{
        let node =  NodeEntity(context: context)
        node.id = self.id
        node.title = self.title
        node.content = self.content
        node.create = self.create
        node.update = self.update
        node.nodeType = self.type.rawValue
        node.status = self.status.rawValue
        return node
    }
    
    static func from(node:NodeEntity)->LineNode{

        var nodeType = node.nodeType!
        
        if(nodeType=="碎碎念"){nodeType = "nagging"}
        if(nodeType=="任务"){nodeType = "task"}
        if(nodeType=="里程碑"){nodeType = "milestone"}
        if(nodeType=="订阅卡"){nodeType = "subscribe"}
        if(nodeType=="纪念卡"){nodeType = "count"}
        
        let node = LineNode(
            id:node.id!,
            title: node.title!,
            type:  NodeType(rawValue: nodeType) ?? NodeType.unowned,
            create: node.create ?? Date(),
            update: node.update ?? Date(),
            content: node.content,
            status: NodeStatus(rawValue: node.status ?? "未知") ?? .unowned
        )
        return node
        
    }
}
