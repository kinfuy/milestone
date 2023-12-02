//
//  ProjectModel.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/13.
//

import SwiftUI
import CoreData


enum SortOption: Int, CaseIterable {
    case desc = 2
    case asc = 1
}

struct Project:Identifiable, Equatable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.update == rhs.update &&
        lhs.create == rhs.create &&
        lhs.icon == rhs.icon &&
        lhs.isTop == rhs.isTop
    }
    
    var id: UUID = UUID()
    var name:String
    var update:Date
    var create:Date
    var icon: String
    var iconColor: Color
    var sort:SortOption = .asc
    var tags: [Tag] = []
    var timeLines:[TimeLine] = []
    var isTop:Bool
    
    init(id:UUID? ,name: String, update: Date = Date(), create: Date = Date(), icon: String, iconColor: Color, tags: [Tag] = [], timeLines: [TimeLine] = [],sort:SortOption = .desc, isTop:Bool = false) {
        self.id = id ?? UUID()
        self.name = name
        self.update = update
        self.icon = icon
        self.iconColor = iconColor
        self.tags = tags
        self.timeLines = timeLines
        self.create = create
        self.sort = sort
        self.isTop = isTop
    }
    
    static func into(context:NSManagedObjectContext)-> ProjectEntity {
        let project =  ProjectEntity(context: context)
        return project
        
    }
    
    static func from(project:ProjectEntity)-> Project {
        
        let tags = project.tags?.allObjects as! [TagEntity]
        let timelines = project.timelines?.allObjects as! [TimeLineEntity]
        let project = Project(
            id:project.id,
            name: project.name!,
            update: project.update ?? Date(),
            create: project.create ?? Date(),
            icon: project.icon!,
            iconColor: Color(hex: project.iconColor!),
            tags: tags.map({Tag.from(tag:$0)}).sorted { $0.create < $1.create },
            timeLines: timelines.map({TimeLine.from(timeLine:$0)}).sorted { $0.create < $1.create },
            isTop: project.isTop
        )
        return project
    }
    
    static func getNew()->Project{
        return Project(id:nil, name: "", icon: "📖", iconColor: Color("GreenColor"))
    }
    
    
    func last(id:UUID?) -> TimeLine? {
        if id != nil {
            guard let idx = self.timeLines.firstIndex(where: {$0.id==id}) else { return nil }
            if (idx - 1 >= 0){
                return self.timeLines[idx - 1]
            }else {
                return self.timeLines[idx]
            }
            
        }
        else {
            return self.timeLines.first
        }
    }
    
    func next(id:UUID?) -> TimeLine? {
        if id != nil {
            guard let idx = self.timeLines.firstIndex(where: {$0.id==id}) else { return nil }
            if (idx + 1 < self.timeLines.count){
                return self.timeLines[idx + 1]
            }else {
                return self.timeLines[idx]
            }
        }
        else {
            return self.timeLines.first
        }
    }
    
}
