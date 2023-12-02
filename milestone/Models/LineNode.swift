//
//  LineNodeModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI
import CoreData

enum NodeType: String,Identifiable, CaseIterable, Codable{
    var id: RawValue {rawValue}
    case nagging = "碎碎念"
    case task = "任务"
    case milestone = "里程碑"
    case subscribe = "订阅"
    case count = "纪念日"
//    case travel = "旅游"
//    case traffic = "交通"
    case unowned = "未知"
    
    var icon: SFSymbol {
        switch self {
        case .milestone:
            return SFSymbol.flag
        case .nagging:
            return SFSymbol.message
        case .task:
            return SFSymbol.clock
//        case .travel:
//            return SFSymbol.signpost
        case .subscribe:
            return SFSymbol.cart
//        case .traffic:
//            return SFSymbol.airplane
        case .count:
            return SFSymbol.calendar
        default:
            return SFSymbol.clock
        }
        
    }
    
    static var list:[NodeType] {
        return NodeType.allCases.filter({$0.rawValue != "未知"})
    }
    
    var text: String {
        return self.rawValue
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
            return "订阅节点"
//        case .travel:
//            return "地标打卡"
//        case .traffic:
//            return "交通工具"
        case .count:
            return "重要日子"
            
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
        return self != .complete
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
    
    func into(context:NSManagedObjectContext)->NodeEntity{
        let node =  NodeEntity(context: context)
        node.id = self.id
        node.title = self.title
        node.content = self.content
        node.create = self.create
        node.update = self.update
        node.startTime = self.startTime
        node.endTime = self.endTime
        node.nodeType = self.type.rawValue
        node.status = self.status.rawValue
        return node
    }
    
    static func from(node:NodeEntity)->LineNode{
        let node = LineNode(
            id:node.id!,
            title: node.title!,
            type:  NodeType(rawValue: node.nodeType!) ?? NodeType.unowned,
            create: node.create ?? Date(),
            update: node.update ?? Date(),
            content: node.content,
            startTime: node.startTime ?? nil,
            endTime: node.endTime ?? nil,
            status: NodeStatus(rawValue: node.status ?? "未知") ?? .unowned
        )
        return node
        
    }
    
    var remainder:String? {
        if let end = self.endTime {
            return DateClass.compareCurrentTime(time: end)
        }
        return nil
       
    }
}
