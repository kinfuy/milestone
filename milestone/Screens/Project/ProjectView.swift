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
                projecManagetModel.setCurrent(id: nil)
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
            .environmentObject(projecManagetModel)
            
        })
        .padding([.leading,.trailing])
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
    
    @State var project: Project
    
    
    var body:some View {
        ZStack{
            BgView()
            VStack{
                TimeLineView(project: project)
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
                
            }, label: {
                VStack{
                    Text("排序")
                    Spacer()
                    SFSymbol.sort
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
    }
    
}

struct ProjectView: View {
    @State private var sheetStatus:Bool  = false
    
    @State private var editSheetStatus:Bool  = false
    
    @ObservedObject var projecManagetModel = ProjectManageModel()
    @State private var editProject:Project? = nil
    
    var body: some View {
        VStack(content: {
            NavHeader
            if(projecManagetModel.projects.count==0){
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
                Spacer()
            }else{
                ScrollView(content: {
                    ForEach(projecManagetModel.projects){ item in
                        NavigationLink(destination: {
                            ProjectDeatilView(project: item)
                                .environmentObject(projecManagetModel)
                        }, label: {
                            ProjectCard(project:item)
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        projecManagetModel.setCurrent(id: item.id)
                                        self.$sheetStatus
                                            .wrappedValue
                                            .toggle()
                                    }) {
                                        Text("编辑")
                                    }
                                    Button(action: {
                                       
                                    }) {
                                        Text("置顶")
                                        
                                    }
                                    
                                    Button(action: {
                                        projecManagetModel.delete(id: item.id)
                                    }) {
                                        Text("删除")
                                    }
                                    
                                    
                                })
                                .padding([.leading,.trailing],20)
                                
                          }
                        )
                        .sheet(isPresented: self.$editSheetStatus, content: {
                            EditProejct(
                                state: self.$editSheetStatus
                            )
                            .onDisappear(){
                                projecManagetModel.setCurrent(id: nil)
                            }
                        })
                        .environmentObject(projecManagetModel)
                        .buttonStyle(PlainButtonStyle())
                       
                    }
                })
            }
            
        })
        .onAppear(){
            projecManagetModel.fetch()
        }
    }
}



struct Project_Previews: PreviewProvider {
    static var projectList = ProjectModel()
    static var previews: some View {
        ScreenManage()
            .environmentObject(projectList)
    }
}
