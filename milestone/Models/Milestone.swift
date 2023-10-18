//
//  MilestoneModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI


enum ValueType:String, Codable {
    case sum = "sum"
    case average = "average"
    case max = "max"
    case min = "min"
}

struct Milestone:Identifiable,Codable {
    var id: UUID = UUID()
    var target: Int
    var source: Int
    var unit:String?;
    var label:String;
    var valueType: ValueType
    
    
    func display() -> String {
        return "\(self.source)/\(self.target)"
    }
    
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
    
}
