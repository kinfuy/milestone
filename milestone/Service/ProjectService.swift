//
//  ProjectService.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/14.
//

import SwiftUI
import CoreData

class ProjectService {
    static var viewContent:NSManagedObjectContext {
      ProjectProvider.shared.container.viewContext
    }
    
    static func save () throws {
        try viewContent.save()
    }
}
