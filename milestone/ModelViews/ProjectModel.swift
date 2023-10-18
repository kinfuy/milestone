import SwiftUI
import CoreData

//let defaultProject =  [
//    Project(
//        id: UUID(),
//        name: "100天完成一个App",
//        update: Date(),
//        icon: Icon(sfsymbol: SFSymbol.sunMin),
//        iconColor:Color.green,
//        tags: [Tag(title: "学", color: Color.green, icon: Icon(sfsymbol: SFSymbol.walk))],
//        timeLines: [
//            TimeLine(name: "运营推广",icon: Icon(sfsymbol: SFSymbol.moon),
//                     nodes: [
//                        LineNode(createTime: Date(), text: "建立小红书账号", type: NodeType.milestone),
//                        LineNode(createTime: Date(), text: "今天发布了一篇文章", type: NodeType.nagging),
//                        LineNode(createTime: Date(), text: "明天准备写一篇关于独立开发入门的文章", type: NodeType.task),
//                        LineNode(createTime: Date(), text: "小红书获得50个粉丝", type: NodeType.milestone),
//                        LineNode(createTime: Date(), text: "累计发布20篇文案", type: NodeType.milestone)
//                     ],
//                     milestone: [
//                        Milestone(target: 2000, source: 50, unit: "个",label:"粉丝", valueType: ValueType.max),
//                        Milestone(target: 100, source: 23, unit: "篇",label: "文章", valueType: ValueType.max),
//                        Milestone(target: 1000, source: 100, unit: "¥",label: "收入", valueType: ValueType.max)
//                     ]
//                    ),
//            TimeLine(name: "开发学习",icon: Icon(sfsymbol: SFSymbol.moon),
//                     nodes: [
//                        LineNode(createTime: Date(), text: "学习swift ui", type: NodeType.milestone),
//                        LineNode(createTime: Date(), text: "自定义tabbar", type: NodeType.nagging),
//                        LineNode(createTime: Date(), text: "深色模式", type: NodeType.task),
//                     ],
//                     milestone: [
//                        Milestone(target: 2000, source: 0, unit: "小时", label: "学习",valueType: ValueType.sum)
//                     ]
//                    ),
//            TimeLine(name: "产品设计",icon: Icon(sfsymbol: SFSymbol.moon),
//                     nodes: [
//                        LineNode(createTime: Date(), text: "LOGO设计", type: NodeType.milestone),
//                        LineNode(createTime: Date(), text: "制作启动闪页", type: NodeType.nagging),
//                        LineNode(createTime: Date(), text: "构思多时间线模式", type: NodeType.task),
//                     ],
//                     milestone: [
//                        Milestone(target: 20, source: 0, unit: "页", label: "设计",valueType: ValueType.sum)
//                     ]
//                    )
//        ]
//    ),
//    Project(
//        id: UUID(),
//        name: "去拉萨",
//        update: Date(),
//        icon: Icon(sfsymbol: SFSymbol.airplane),
//        iconColor: Color.pink,
//        tags: [Tag(title: "旅", color: Color.green,icon: Icon(sfsymbol: SFSymbol.walk)), Tag(title: "旅", color: Color.green)],
//        timeLines: [
//            TimeLine(name: "存钱计划",icon: Icon(sfsymbol: SFSymbol.crown), nodes: [
//                LineNode(createTime: Date(), text: "旅行资金累计2000", type: NodeType.milestone),
//            ])
//        ]
//    ),
//    
//    Project(
//        id: UUID(),
//        name: "里程碑之约",
//        update: Date(),
//        icon: Icon(sfsymbol: .fossilShell),
//        iconColor: Color.purple,
//        tags: [
//            Tag(title: "官", color: Color.orange),
//            Tag(color: Color.accentColor,icon: Icon(sfsymbol: SFSymbol.time))],
//        timeLines: [
//            TimeLine(name: "里程碑足迹",icon: Icon(sfsymbol: SFSymbol.walk), nodes: [
//                LineNode(createTime: Date(), text: "下载里程碑App", type: NodeType.milestone),
//                LineNode(createTime: Date(), text: "创建一个项目", type: NodeType.nagging),
//                LineNode(createTime: Date(), text: "使用里程碑7天", type: NodeType.task)
//            ])
//        ]
//    )
//]


class ProjectManageModel:ObservableObject {
    @Published var projects:[Project] = []
    
    @Published var currentProject:Project?
    
    let container:NSPersistentContainer
    
    func setCurrent(id:UUID?){
        if((id) != nil){
            self.currentProject = getProject(id: id!)
        }else{
            self.currentProject = nil
        }
       
    }
    
    init(){
        container = NSPersistentContainer(name: "ProjectDB")
        container.loadPersistentStores{_,error in
            if let error = error{
                print(error.localizedDescription)
            }else {
               
            }
        }
        self.fetch()
    }
    
    func fetch(){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        
        do {
            let projectEntity = try container.viewContext.fetch(request)
            if projectEntity.isEmpty {
                self.projects = []
                return
            }
            self.projects = Project.rebuildProjects(entitys: projectEntity)
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func save(){
        do {
            try container.viewContext.save()
            fetch()
        } catch  {
           
        }
    }
    
    private func replace(projectEntity:ProjectEntity,project:Project)->ProjectEntity{
        projectEntity.name = project.name;
        projectEntity.update = project.update
        
        projectEntity.iconColor = project.iconColor.toHex
        do {
            projectEntity.tags = try project.tags.toString()
        } catch {
            print("\(error.localizedDescription)")
            projectEntity.tags = "[]"
        }
       
        projectEntity.timeLines = "[]"
        
        projectEntity.icon = project.icon
        return projectEntity
    }
    
    func add(project:Project){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate = NSPredicate(format: "id = \"\(project.id)\"")
        do {
            let projectEntity = try container.viewContext.fetch(request)
            if projectEntity.isEmpty {
                var projectEntity = ProjectEntity(context: container.viewContext)
                projectEntity.id =  project.id;
                projectEntity.create =  Date()
                projectEntity = replace(projectEntity: projectEntity, project: project)
                save()
            }else {
                update(project: project)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        
       
    }
    
    func delete(id: UUID){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        do {
            let projectEntity = try container.viewContext.fetch(request)
            if !projectEntity.isEmpty {
                container.viewContext.delete(projectEntity[0])
                if container.viewContext.hasChanges {
                    save()
                }
            }
        } catch  {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func update(project:Project){
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate =  NSPredicate(format: "id = \"\(project.id)\"")
        do {
            var projectEntity = try container.viewContext.fetch(request)
            if !projectEntity.isEmpty {
                projectEntity[0] = replace(projectEntity: projectEntity[0], project: project)
                if container.viewContext.hasChanges {
                    save()
                }
            }
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func getProject(id:UUID)->Project? {
        if let project = self.projects.first(where: {$0.id==id}) {
          return project
        } else {
           return nil
        }
    }

}


class ProjectModel:ObservableObject {
    @Published var project: Project?
    @Published var isLoading: Bool = false
    
    @Published var current:Int = 0
    
    @Published var isEdit = false

    
    func initProject(project:Project?)->Project{
        if(project != nil){
            self.project = project
            isEdit = true
        }else {
           self.project = Project.getNew()
        }
        return self.project!
    }
    
    func initProject(id:UUID)->Project{
        self.project = Project.getNew()
        isEdit = true
        return self.project!
    }
    
    func initProject(){
        self.project = Project.getNew()
        isEdit = false
    }
    
    var timeLines: [TimeLine] {
        project?.timeLines ?? []
    }
    
    var timeLine:TimeLine? {
        return timeLines[current]
    }
    
    var total:Int {
        timeLines.count
    }
    
    var isStart:Bool {
        current == 0
    }
    var isEnd: Bool {
        current == total - 1
    }
    
    func switchTab(type: String){
        let idx =  type == "last" ? -1 : 1
        if(self.current + idx > self.total - 1){
            self.current  = self.total - 1
        }else if(self.current + idx < 0) {
            self.current  =  0
        }
        else{
            self.current = self.current + idx
        }
    }
}
