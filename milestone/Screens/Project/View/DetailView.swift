

import SwiftUI

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
            Button(action: {}, label: {
                VStack{
                    Text("总览")
                    Spacer()
                    SFSymbol.cart
                }
            })
            Button(action: {
                projectModel.setOrder(order: .asc)
            }, label: {
                VStack{
                    Text("排序".lowercased())
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
        .onAppear {
            projectManageModel.setCurrent(id: project.id)
            if (projectModel.project == nil) {
                projectModel.initProject(project: projectManageModel.currentProject)
            }
        }
    }
    
}

