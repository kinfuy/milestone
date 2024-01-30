import SwiftUI
import JDStatusBarNotification

struct ProjectView: View {
    @ObservedObject  var projectManageModel = ProjectManageModel()
    @State private var rightSliding: UUID?
    
    @State private var sheetStatus:Bool  = false
    @State private var editSheetStatus:Bool  = false
    @State private var editProject:Project? = nil
    @State private var isActives: [Bool] = []
    @State private var confirm:Bool = false
    @State private var deleteTips:String = ""
    @State private var shouldNavigate:Bool = false
    
    @State private var current:Project?
    
    func open(val:Bool){
        self.sheetStatus = val
    }
    
    func deleteAlert()->Alert {
        Alert(title:Text("删除《\(self.deleteTips)》"),
              message: Text("删除项目将删除相关所有内容，是否继续？"),
              primaryButton: .default(
                Text("取消")
              ),
              secondaryButton: .destructive(
                Text("删除"),
                action: {
                    if let id = current?.id {
                        projectManageModel.delete(id: id)
                    }
                    else {
                        NotificationPresenter.shared.presentSwiftView {
                            HStack{
                                SFSymbol.warn.foregroundColor(.red)
                                Text("删除目标似乎不见了!")
                            }
                        }
                        NotificationPresenter.shared.dismiss(after: 1.5)
                    }
                    rightSliding = nil
                    deleteTips = ""
                }
              )
              
        )
    }
    
    func createContentMenu(item:Project) -> some View {
        VStack {
            createMenuItem(text: "编辑", onAction: {
                projectManageModel.setCurrent(id: item.id)
                self.open(val: true)
            })
            let topTitle = item.isTop ? "取消置顶" : "置顶"
            createMenuItem(text: topTitle, onAction: {
                projectManageModel.setTop(id: item.id,val: !item.isTop)
            })
            createMenuItem(text: "删除", onAction: {
                current = item
                self.confirm.toggle()
                self.deleteTips = item.name
               
            })
            
        }
    }
    
    var body: some View {
        VStack(content: {
            NavHeader
            if(projectManageModel.projects.isEmpty){
                EmptyView
                Spacer()
            } else {
                ListView
            }
            
        })
        .onAppear(){
            projectManageModel.fetch()
        }
        .padding(.bottom, 68)
    }
    
    
    var NavHeader: some View {
        HStack(content: {
            Text("项目")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
            Button(action: {
                projectManageModel.setCurrent(id: nil)
                self.$sheetStatus
                    .wrappedValue
                    .toggle()
            }, label: {
                SFSymbol.plus
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
            })
            .sheet(isPresented: self.$sheetStatus, content: {
                EditProejct(state: self.$sheetStatus)
            })
            .environmentObject(projectManageModel)
            
        })
        .padding([.leading,.trailing])
    }
    
    var EmptyView: some View {
        VStack{
            Button(action: {
                self.$sheetStatus
                    .wrappedValue
                    .toggle()
            }, label: {
                Text("创建项目").font(.title)
            })
            Text("这里什么都没有，快创建一个项目吧").foregroundColor(.secondary)
        }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding()
    }
    
    var ListView:some View {
        ScrollView(content: {
            ForEach(projectManageModel.projects){ item in
                ProjectCard(
                    sheetStatus: $sheetStatus,
                    rightSliding: $rightSliding,
                    confirm:$confirm,
                    deleteTips:$deleteTips,
                    project:item,
                    onCardTap:{
                        if rightSliding == nil {
                            shouldNavigate = true // 触发导航
                            rightSliding = nil
                        }else {
                            current = item
                        }
                    }
                    
                )
                .environmentObject(projectManageModel)
                .contextMenu { createContentMenu(item:item) }
                .padding([.leading,.trailing],20)
                .alert(isPresented: self.$confirm){
                    deleteAlert()
                }
                .sheet(isPresented: self.$editSheetStatus, content: {
                    EditProejct(
                        state: self.$editSheetStatus
                    )
                    .onDisappear(){
                        projectManageModel.setCurrent(id: nil)
                    }
                })
                .environmentObject(projectManageModel)
                .buttonStyle(PlainButtonStyle())
                .navigationDestination(isPresented:  $shouldNavigate, destination: {
                    ProjectDeatilView(project: item).environmentObject(projectManageModel)
                })
                
            }
            
        })
        .animation(.spring, value: projectManageModel.projects)
    }
}



struct Project_Previews: PreviewProvider {
    static var projectList = ProjectModel()
    static var previews: some View {
        ScreenManage()
            .environmentObject(projectList)
    }
}
