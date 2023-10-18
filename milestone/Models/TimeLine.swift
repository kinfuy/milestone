//
//  TimeLineModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI



struct TimeLine:Identifiable,Codable {
    var id: UUID
    var name:String
    var icon: Icon
    var nodes: [LineNode] = []
    var milestone:[Milestone] = []
    
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
}
