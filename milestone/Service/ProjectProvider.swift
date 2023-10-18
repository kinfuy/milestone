//
//  ProjectProvider.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/14.
//

import Foundation
import CoreData

class ProjectProvider {
    static let shared = ProjectProvider()
    let container:NSPersistentContainer
    init(){
        container = NSPersistentContainer(name:"project")
        container.loadPersistentStores{_,error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
