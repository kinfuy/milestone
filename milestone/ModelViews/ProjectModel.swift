import SwiftUI
import CoreData


class ProjectManageModel:ObservableObject {
    @Published var projects:[Project] = []
    @Published var currentProject:Project?
    private var service = ProjectService()
    private var tagService = TagService()
    
    init(){
        self.fetch();
    }
    
    func setCurrent(id:UUID?){
        if((id) != nil){
            self.currentProject = getProject(id: id!)
        }else{
            self.currentProject = nil
        }
        
    }
    
    func setTop(id:UUID,val: Bool){
        var project = getProject(id: id)
        project?.isTop = val
        if(project != nil){
            self.update(project: project!)
        }
    }
    
    func fetch(){
        self.projects = service.findAll()
    }
    
    func add(project:Project,tags:[Tag]){
        service.add(project)
        self.fetch()
    }
    
    func delete(id: UUID){
        service.delete(id: id)
        self.fetch()
    }
    
    func update(project:Project){
        service.update(project)
        self.fetch()
    }
    
    func getProject(id:UUID)->Project? {
        if let project = self.projects.first(where: {$0.id==id}) {
            return project
        } else {
            return nil
        }
    }
    
}


class ProjectModel: ObservableObject {
    @Published var project: Project?
    @Published var isLoading: Bool = false
    @Published var current:UUID?
    @Published var isEdit = false
    @Published var editNode:LineNode?
    @Published var editTimeLIne:TimeLine?
    
    private var service = ProjectDeatilService()
    
    private var timelineService = TimeLineService()
    
    private var nodeService = NodeService()
    
    func setOrder(order: SortOption){
        project?.sort = order;
    }
    
    func initEditNode(node:LineNode){
        editNode = node
    }
    func initEditNode(type:NodeType){
        editNode = LineNode(title: "", type: type, create: Date(), update: Date())
        editNode!.isEdit = true
    }
    
    func initEditTimeline(line:TimeLine){
        editTimeLIne = line
    }
    
    func initEditTimeline(){
        editTimeLIne = TimeLine(id: UUID(), name: "", icon: Icon(emoji: "🗒️"), create: Date(), update: Date())
        editTimeLIne!.isEdit = true
    }
    
    
    var currentIndex:Int {
        return self.project?.timeLines.firstIndex(where: {$0.id == self.current}) ?? 0
    }
    
    // 清除编辑状态
    func clearEdit(){
        editNode = nil
        editTimeLIne = nil
    }
    
    
    // 是否打开高级配置
    var nodeSenior:Bool {
        if let node = editNode {
            return node.startTime != nil
        }else {
            return false
        }
    }
    
    
    func fetch(){
        if let id = project?.id {
            self.project = service.find(id: id)
        }
        
    }
    
    func initProject(project:Project?){
        if(project != nil){
            self.project = project
            isEdit = true
        }else {
            self.project = Project.getNew()
        }
        current = self.project?.timeLines.first?.id
    }
    
    func initProject(id:UUID)->Project{
        self.project = Project.getNew()
        isEdit = true
        current = self.project?.timeLines.first?.id
        return self.project!
        
    }
    
    func initProject(){
        self.project = Project.getNew()
        isEdit = false
        current = self.project?.timeLines.first?.id
    }
    
    var timeLines: [TimeLine] {
        return project?.timeLines ?? []
    }
    
    var timeLine:TimeLine? {
        return project?.timeLines.first(where: {$0.id == self.current})
    }
    
    var total:Int {
        timeLines.count
    }
    
    var isStart:Bool {
        if let first = project?.timeLines.first?.id, let cur =  self.current{
            return first == cur
        }
        return false
    }
    
    var isEnd: Bool {
        if let end = project?.timeLines.last?.id, let cur =  self.current{
            return end == cur
        }
        return false
    }
    
    func isShowGap(nodeId:UUID)->Bool {
        return timeLine?.gapNode(nodeId: nodeId,order: project?.sort) ?? false
    }
    
    func addTimeLine(timeLine:TimeLine){
        if let projectId = project?.id {
            timelineService.createOrUpdate(line: timeLine, belongId: projectId)
            self.fetch()
            self.current = timeLine.id
        }
    }
    
    func deleteTimeline(id:UUID){
        timelineService.delete(id: id)
        self.switchTab(type: "last")
        self.fetch()
    }
    
    func addNode(node:LineNode){
        if(self.timeLine != nil){
            nodeService.createOrUpdate(node: node, belongId: self.timeLine!.id)
            self.fetch()
        }
        
    }
    
    func deleteNode(id:UUID){
        if(self.timeLine != nil){
            nodeService.delete(id: id)
            self.fetch()
        }
    }
    
    
    
    func switchTab(type: String){
        if(type == "next") {
            self.current =  self.project?.next(id: self.current)?.id
        }
        if(type == "last"){
            self.current =  self.project?.last(id: self.current)?.id
        }
    }
    
    func updateNode(node:LineNode){
        nodeService.update(node: node)
        self.fetch()
    }
    
    
    func moveNode(node:LineNode, belongId:UUID){
        if let belong  =  node.belong {
            if(belong != belongId){
                nodeService.move(node: node, belongId: belongId)
                self.fetch()
            }
            
        }
        
    }
    
    func getNode(id:UUID)-> LineNode? {
        return timeLine?.nodes.first(where: {$0.id == id})
    }
    
    func moveNode(nodeId:UUID, belongId:UUID){
        if let node = self.getNode(id:nodeId) {
            if let belong  =  node.belong {
                if(belong != belongId){
                    nodeService.move(node: node, belongId: belongId)
                    self.fetch()
                }
                
            }
            
        }
    }
}
