//
//  Project.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI


extension ProjectView {
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
}

//扩展实现侧滑返回
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct ProjectDeatilView:View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var projectManageModel: ProjectManageModel
    
    @State var project: Project
    @StateObject var projectModel: ProjectModel = ProjectModel()
    
    var body:some View {
        ZStack{
            BgView()
            VStack{
                TimeLineView(project: project)
                    .environmentObject(projectModel)
            }
            .clipped()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(project.name)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Group{
                SFSymbol.back.onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.foregroundStyle(Color.gray)
        })
        )
        .navigationBarItems(trailing: Menu(content: {
            Button(action: {
                projectModel.setOrder(order: .asc)
            }, label: {
                VStack{
                    Text("排序")
                    Spacer()
                    SFSymbol.sort
                }
            })
            Button(action: {
                projectModel.setOrder(order: .desc)
            }, label: {
                VStack{
                    Text("正序")
                    Spacer()
                    SFSymbol.down
                }
            })
            Button(action: {
                
            }, label: {
                VStack{
                    Text("倒序")
                    Spacer()
                    SFSymbol.up
                }
            })
            Button(action: {
                
            }, label: {
                VStack{
                    Text("设置")
                    Spacer()
                    SFSymbol.set
                }
            })
        }, label: {
            SFSymbol.ellipsis.foregroundStyle(Color.gray)
        })
        )
        .onAppear {
            projectManageModel.setCurrent(id: project.id)
            if (projectModel.project == nil) {
                projectModel.initProject(project: projectManageModel.currentProject)
            }
        }
    }
    
}

struct ProjectView: View {
    @State private var sheetStatus:Bool  = false
    
    @State private var editSheetStatus:Bool  = false
    
    @ObservedObject var projectManageModel = ProjectManageModel()
    @State private var editProject:Project? = nil
    
    @State var rightSliding: UUID?
    
    @State private var isActives: [Bool] = []
    
    
    func open(val:Bool){
        self.sheetStatus = val
    }
    
    var body: some View {
        VStack(content: {
            NavHeader
            if(projectManageModel.projects.count==0){
                EmptyView
                Spacer()
            }else if(isActives.count > 0 ){
                ScrollView(content: {
                    ForEach(projectManageModel.projects){ item in
                        NavigationLink(
                             destination: ProjectDeatilView(project: item)
                                   .environmentObject(projectManageModel),
                             isActive: $isActives[projectManageModel.projects.firstIndex(of: item)!],
                             label: {
                                ProjectCard(
                                    project:item,rightSliding: $rightSliding, sheetStatus: $sheetStatus)
                                     .environmentObject(projectManageModel)
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        projectManageModel.setCurrent(id: item.id)
                                        self.open(val: true)
                                    }) {
                                        Text("编辑")
                                    }
                                    if(!item.isTop){
                                        Button(action: {
                                            projectManageModel.setTop(id: item.id,val: true)
                                        }) {
                                            Text("置顶")
                                        }
                                    }else{
                                        Button(action: {
                                            projectManageModel.setTop(id: item.id,val: false)
                                        }) {
                                            Text("取消置顶")
                                        }
                                    }
                                
                                    Button(action: {
                                        projectManageModel.delete(id: item.id)
                                    }) {
                                        Text("删除")
                                    }
                                    
                                    
                                })
                                .padding([.leading,.trailing],20)
                                .onTapGesture {
                                    if(rightSliding == nil){
                                        isActives[projectManageModel.projects.firstIndex(of: item)!] = true
                                    }
                                    rightSliding = nil
                                }
                          }
                        )
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
                       
                    }
                })
                .animation(.spring, value: projectManageModel.projects)
            }
            
        })
        .onAppear(){
            projectManageModel.fetch()
            // 动态创建isActives数组，和items数目保持一致
            isActives = Array(repeating: false, count: projectManageModel.projects.count)
         
        }
        .padding(.bottom, 68)
    }
}



struct Project_Previews: PreviewProvider {
    static var projectList = ProjectModel()
    static var previews: some View {
        ScreenManage()
            .environmentObject(projectList)
    }
}
