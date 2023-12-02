//
//  LineNodeView.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/30.
//

import SwiftUI




extension LineNodeView {
    
    struct NaggingNode: View {
        @State var node:LineNode
        var body:some View {
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    Text(node.title).font((.system(size: 18)))
                    if let content = node.content{
                        Text(content).font((.system(size: 16))).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding(.vertical,4)
            .padding(.horizontal)
        }
    }
    
    struct TaskNode: View {
        @EnvironmentObject var projectModel: ProjectModel
        @State var node:LineNode
        var body:some View {
            VStack{
                HStack{
                    VStack(alignment: .leading,spacing: 0){
                        Text(node.title).font((.system(size: 18)))
                        Spacer()
                        if let content = node.content{
                            Text(content)
                                .font((.system(size: 16)))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        HStack{
                            Text("任务")
                                .lineTag(color:Color("BlueColor"))
                            if(node.status == .complete) {
                                Text(node.status.text).lineTag(color:Color("GreenColor"))
                            }
                            if let remainder = node.remainder {
                                Text(remainder)
                                    .lineTag(color:Color("GreenColor"))
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color("WriteColor"))
                .cornerRadius(8)
                HStack{
                    Spacer()
                    HStack{
                        if(node.status.canCompleted){
                            HStack(spacing: 4){
                                Button("完成", action: {
                                    node.status = .complete
                                    projectModel.updateNode(node: node)
                                })
                            }.padding(.horizontal,12)
                                .padding(.vertical,6)
                                .background(Color("BlueColor").opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.leading, 12)
            .padding(.vertical, 10)
        }
    }
    
    struct MilestoneNode:View {
        @State var node:LineNode
        var body:some View {
            HStack{
                VStack(alignment: .leading,spacing: 0){
                    Text(node.title).font((.system(size: 18)))
                    if let content = node.content{
                        Text(content).font((.system(size: 16))).foregroundColor(.gray)
                    }
                    Text(MMDDHHMM.string(from: node.create))
                        .font(.caption)
                }
                Spacer()
                VStack{
                    HStack{
                        node.type.icon.foregroundColor(Color("GreenColor"))
                            .padding(.trailing,10)
                    }
                    Spacer()
                }
            }
            .padding(.leading, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color("WriteColor"))
            .cornerRadius(8)
            .padding(.leading, 12)
            .padding(.vertical, 10)
            
        }
    }
    
    struct NodeView:View {
        @EnvironmentObject var projectModel: ProjectModel
        @State var node:LineNode
        @State var editStatus = false
        
        func close (){
            editStatus = false
        }
        var body: some View {
            HStack{
                switch node.type {
                case .milestone:
                    MilestoneNode(node: node)
                case .nagging:
                    NaggingNode(node: node)
                case .task:
                    TaskNode(node: node)
              
                default:
                    HStack{
                        Text("全新节点请更新版本查看").card()
                        Spacer()
                    }
                }
            }
            .contextMenu(menuItems: {
                Button(action: {
                    self.projectModel.initEditNode(node: node)
                    self.editStatus.toggle()
                }) {
                    Text("编辑")
                }
                Button(action: {
                    self.projectModel.moveNode(node: node,belongId: nil)
                }) {
                    Text("移动")
                }
                if( node.status == .complete){
                    Button(action: {
                        node.status = .progress
                        projectModel.updateNode(node: node)
                    }) {
                        Text("重启任务")
                    }
                }
                Button(action: {
                    self.projectModel.deleteNode(id: node.id)
                }) {
                    Text("删除")
                }
            })
            .sheet(isPresented: self.$editStatus){
                EditNode(
                    state: self.$editStatus,
                    close: close
                )
            }
            .environmentObject(projectModel)
        }
    }
}




struct LineNodeView: View {
    @State var lineType:NodeType = .nagging
    @State var node:LineNode
    var body: some View {
        HStack{
            HStack{
                LineView(width: 2)
                VStack(alignment: .leading){
                    HStack{
                        Group{
                            SFSymbol.time
                            Text(MMDDHHMM.string(from: node.create))
                        }
                        .font(.caption)
                        .foregroundColor(Color("Gray2"))
                    }
                    .padding(.leading, 12)
                    NodeView(node: node)
                }
                .padding(.top)
                
            }
            .padding(.leading)
        }
        
    }
}

//#Preview {
//    LineNodeView()
//}
