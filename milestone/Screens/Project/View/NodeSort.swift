//
//  NodeSort.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/12/4.
//

import SwiftUI
extension NodeSort {
    var NavView:some View {
        HStack{
            Button("取消", action: {
                self.close()
            })
            Spacer()
            Text("移动到目标时间线").fontWeight(.bold)
            Spacer()
            Button("完成", action: {
               
                if let belongId = self.selected, let node = projectModel.editNode {
                    self.projectModel.moveNode(node: node, belongId: belongId)
                    self.close()
                }
               
            })
        }
        .padding(.vertical)
    }
    
}

struct NodeSort:View {
    
    @EnvironmentObject var projectModel: ProjectModel
    @Binding var state:Bool
    
    var close:()-> Void
    
    @State var selected:UUID?
    
    func getSelectLine() -> [TimeLine]{
        if let belong = projectModel.editNode?.belong {
            return projectModel.timeLines.filter({$0.id != belong})
        }
        return projectModel.timeLines
    }
    var body: some View {
        ZStack{
            BgView()
            VStack{
                NavView
                ScrollView(content: {
                    ForEach(Array(getSelectLine().enumerated()), id: \.element.id) { line in
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text(line.element.name)
                                        .font(.title3)
                                    if(line.element.milestone.count>0){
                                        VStack{
                                            HStack(alignment:.bottom){
                                                Group{
                                                    Text(line.element.milestone[0].label)
                                                    Text(":")
                                                }.foregroundColor(.gray)
                                                Text(line.element.milestone[0].display())
                                                    .foregroundColor(Color("GreenColor"))
                                                Text(line.element.milestone[0].unit ?? "")
                                                    .foregroundColor(.gray)
                                                    .font(.caption)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                line.element.icon.display()
                                    .frame(width: 24,height: 24)
                                    .foregroundColor(Color("BlueColor"))
                                
                            }
                        }
                        .padding()
                        .background(self.selected == line.element.id ? Color("BlueColor").opacity(0.2) :Color.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.selected = line.element.id
                        }
                        
                        
                    }
                })
                Spacer()
            }
            .padding(.horizontal)
        }
        .onDisappear(){
            self.projectModel.clearEdit()
        }
    }
}

