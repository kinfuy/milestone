import Foundation
import CoreData

class Service {
    static let shared = Service()
    let container:NSPersistentContainer
    init(){
        container = NSPersistentContainer(name:"ProjectDB")
        container.loadPersistentStores{_,error in
            if let error = error{
                self.clean()
                print(error.localizedDescription)
            }
        }
    }
    
    func clean(){
        // 获取 CoreData 数据库文件路径
        let databasePath = self.container.persistentStoreDescriptions.first?.url?.path
        // 删除 CoreData 数据库文件
        try? FileManager.default.removeItem(atPath: databasePath!)
    }
    func refresh(){
        self.container.viewContext.refreshAllObjects()
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
}

// Mark project
class ProjectService: Service {
    private var projectEntitys:[ProjectEntity] = []
    func findAll()-> [Project] {
        do {
            self.refresh()
            let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
            let sortDescriptor = NSSortDescriptor(key: "create", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            let projectEntity =  try container.viewContext.fetch(request)
            self.projectEntitys = projectEntity
            if projectEntity.isEmpty {
                return []
            }
            return projectEntity.map({ Project.from(project: $0)})
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return []
        }
    }
    
    
    func isExit(id:UUID)->ProjectEntity? {
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        guard let projectEntity = try? self.container.viewContext.fetch(request).first else { return nil }
        
        return projectEntity
    }
    
    private func replace(projectEntity:ProjectEntity,project:Project)->ProjectEntity{
        projectEntity.name = project.name;
        projectEntity.update = project.update
        projectEntity.iconColor = project.iconColor.toHex
        projectEntity.icon = project.icon
        projectEntity.tags = NSSet(array: project.tags.map({$0.into(context: self.container.viewContext)}))
//        projectEntity.timelines = NSSet(array: project.timeLines.map({$0.into(context: self.container.viewContext)}))
        return projectEntity
    }
    
    func add(_ project: Project){
        let projectEntity = self.isExit(id: project.id)
        if projectEntity == nil {
            var projectEntity = ProjectEntity(context: self.container.viewContext)
            projectEntity.id =  project.id;
            projectEntity.create =  Date()
            projectEntity = replace(projectEntity: projectEntity, project: project)
            projectEntity.tags = NSSet(array: project.tags.map({$0.into(context: self.container.viewContext)}))
            projectEntity.timelines = NSSet(array: project.timeLines)
            self.save()
        }
        
    }
    
    func delete(id: UUID){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let projectEntity = try self.container.viewContext.fetch(request)
            if !projectEntity.isEmpty {
                self.container.viewContext.delete(projectEntity[0])
                if self.container.viewContext.hasChanges {
                    self.save()
                }
            }
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func update(_ project:Project){
        let projectEntity = self.isExit(id: project.id)
        if var projectEntity = projectEntity {
            projectEntity = replace(projectEntity: projectEntity, project: project)
            if self.container.viewContext.hasChanges {
                self.save()
            }
        }
        
    }
    
}


class ProjectDeatilService:Service {
    private var projectEntity:ProjectEntity?
    func find(id:UUID)-> Project?{
        self.refresh()
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate =  NSPredicate(format: "id = \"\(id)\"")
        let sortDescriptor = NSSortDescriptor(key: "create", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let projectEntity = try container.viewContext.fetch(request)
            if projectEntity.isEmpty {
                self.projectEntity = nil
                return nil
            }
            self.projectEntity = projectEntity[0]
            return Project.from(project: projectEntity[0])
        }
        catch {
            print("Unexpected error: \(error.localizedDescription).")
            return nil
        }
    }
    
    func isExit(id:UUID)->ProjectEntity? {
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        guard let projectEntity = try? self.container.viewContext.fetch(request).first else { return nil }
        
        return projectEntity
    }
}

class TimeLineService:Service {
    func add(timeline:TimeLine,belongId:UUID){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \"\(belongId)\"")
        if let projectEntity = try? self.container.viewContext.fetch(request).first {
            let t = TimeLineEntity(context: self.container.viewContext)
            t.id = timeline.id;
            t.name = timeline.name;
            t.icon = timeline.icon.rawvalue;
            t.create = Date()
            t.update = Date()
            t.belong = projectEntity
            t.nodes = []
            self.save()
        }
        
    }
    
    func delete(id: UUID){
        let request = NSFetchRequest<TimeLineEntity>(entityName: "TimeLineEntity")
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let timeline = try self.container.viewContext.fetch(request)
            if !timeline.isEmpty {
                self.container.viewContext.delete(timeline[0])
                if self.container.viewContext.hasChanges {
                    self.save()
                }
            }
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
}

class MilestoneService:Service {
    
    func find(){}
    
    func add(){
        let milestone = MilestoneEntity(context: self.container.viewContext)
        milestone.id =  UUID()
        milestone.target =  100
        milestone.source =  10
        milestone.unit =  "个"
        milestone.label =  "粉丝"
        milestone.valueType =  ValueType.max.rawValue
    }
    
    func delete(id: UUID){
        let request = NSFetchRequest<MilestoneEntity>(entityName: "MilestoneEntity")
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let milestone = try self.container.viewContext.fetch(request)
            if !milestone.isEmpty {
                self.container.viewContext.delete(milestone[0])
                if self.container.viewContext.hasChanges {
                    self.save()
                }
            }
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
}

class NodeService:Service {
    
    func isExit(id:UUID)->NodeEntity? {
        let request = NSFetchRequest<NodeEntity>(entityName: "NodeEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
       
        guard let nodeEntity = try? self.container.viewContext.fetch(request).first else { return nil }
        return nodeEntity
    }
    
    
    func createOrUpdate(node:LineNode,belongId:UUID?){
        let nodeEntity = self.isExit(id: node.id)
        if let nodeEntity = nodeEntity {
            nodeEntity.content = node.content
            nodeEntity.update = Date()
            nodeEntity.title = node.title
            nodeEntity.startTime = node.startTime
            nodeEntity.endTime = node.endTime
            nodeEntity.status = node.status.rawValue
            if self.container.viewContext.hasChanges {
                self.save()
            }
        }
        else if let id = belongId {
            self.add(node: node, belongId: id)
        }
    }

    
    func add(node:LineNode,belongId:UUID) {
        let request = NSFetchRequest<TimeLineEntity>(entityName: "TimeLineEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \"\(belongId)\"")
        
        if let timeLine = try? self.container.viewContext.fetch(request).first {
            let n = NodeEntity(context: self.container.viewContext)
            n.id = node.id
            n.content = node.content
            n.create = Date()
            n.update = Date()
            n.nodeType = node.type.rawValue
            n.title = node.title
            n.startTime = node.startTime
            n.endTime = node.endTime
            n.status = node.status.rawValue
            n.belong = timeLine
            self.save()
        }
    }
    func delete(id: UUID){
        let request = NSFetchRequest<NodeEntity>(entityName: "NodeEntity")
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let node = try self.container.viewContext.fetch(request)
            if !node.isEmpty {
                self.container.viewContext.delete(node[0])
                if self.container.viewContext.hasChanges {
                    self.save()
                }
            }
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
}

class TagService:Service {
    
}
