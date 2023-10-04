//
//  Project.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI


extension Project {
    var NavHeader: some View {
        HStack(content: {
            Text("我的项目")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
            Button(action: {
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

//extension ProjectDeatilView {
//    var BgView: some View {
//        LinearGradient(gradient: Gradient( colors: [
//            Color.accentColor.opacity(0.05),
//            Color.gray.opacity(0.1)
//        ]),startPoint: .top,endPoint: .bottom)
//        .frame(maxWidth:.infinity,maxHeight: .infinity)
//        .ignoresSafeArea()
//    }
//}

struct ProjectDeatilView:View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var card:IProject
    
    @State var current:Int = 0
    
    
    var body:some View {
        ZStack{
            BgView()
            VStack{
                TimeLineView(
                    timeLines: $card.timeLines,
                    current: self.$current
                )
            }
            .clipped()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(card.name)
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
        .navigationBarItems(trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Group{
                SFSymbol.ellipsis
            }.foregroundStyle(Color.gray)
        })
        )

        
    }
    
}

struct Project: View {
    @State var sheetStatus:Bool  = false
    
    @State var projectList = ProjectModel()
    
    
    var body: some View {
        VStack(content: {
            NavHeader
            ScrollView(content: {
                ForEach(projectList.projects){ item in
                    NavigationLink(destination: {
                        ProjectDeatilView(card: item)
                    }, label: {
                        ProjectCard(name: item.name, icon: item.icon, update: item.update,iconColor: item.iconColor,tags: item.tags)
                            .padding([.leading,.trailing],20)
                    }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
                
                
            })
        })
    }
}


extension Project {}



struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ScreenManage()
    }
}
