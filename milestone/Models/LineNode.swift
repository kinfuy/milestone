//
//  LineNodeModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI

enum NodeType: String, CaseIterable, Codable{
    case nagging = "碎碎念"
    case task = "任务"
    case milestone = "里程碑"
    
    var icon: SFSymbol {
        switch self {
        case .milestone:
            return SFSymbol.flag
        case .nagging:
            return SFSymbol.message
        case .task:
            return SFSymbol.clock
        }
        
    }
    
    var text: String {
        switch self {
        case .milestone:
            return "里程碑"
        case .nagging:
            return "碎碎念"
        case .task:
            return "任务"
        }
        
    }
}


struct LineNode:Identifiable, Codable {
    var id: UUID = UUID()
    var createTime:Date
    var text:String
    var type: NodeType
    var endTime:Date?
}
