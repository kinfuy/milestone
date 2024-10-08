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
                            if(node.status == .expire) {
                                Text(node.status.text).lineTag(color:Color.gray)
                            }
                            if let diffEndTime = node.diffEndTime {
                                Text(diffEndTime)
                                    .lineTag(color: node.needTip
                                             ? Color.red.opacity(0.6) : Color("GreenColor"));
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
                                    node.endTime = Date()
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
    
    
    struct CountNode:View {
        @State var node:LineNode
        var body:some View {
            HStack{
                HStack{
                    SFSymbol.moon
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 32,height: 32)
                        .padding(8)
                        .background(Color("PinkColor"))
                        .cornerRadius(16)
                    VStack{
                        Text(node.title)
                        
                    }
                }
                Spacer()
                HStack{
                    Text("还有").font(.system(size: 14)).foregroundColor(.secondary)
                    Text("78").font(.system(size: 28)).foregroundColor(Color("GreenColor"))
                    Text("天").font(.system(size: 14)).foregroundColor(.secondary)
                }
                Spacer().frame(width: 12)
                
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
    
    struct SubscribeNode:View {
        @State var node:LineNode
        var body:some View {
            HStack{
                HStack{
                    VStack(alignment: .leading){
                        Text(node.title)
                        HStack{
                            Text(MMDD.string(from: node.create))
                                                    .font(.caption)
                            Text("~")
                            Text(MMDD.string(from: node.update))
                                                    .font(.caption)
                        }
                    }
                }
                Spacer()
                HStack{
                    Text("剩余").font(.system(size: 14)).foregroundColor(.secondary)
                    Text("19").font(.system(size: 28)).foregroundColor(Color("BlueColor"))
                    Text("天").font(.system(size: 14)).foregroundColor(.secondary)
                }
                Spacer().frame(width: 12)
                
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
        @EnvironmentObject var projectManageModel:ProjectManageModel
        @State var node:LineNode
        @State var editStatus = false
        
        @State var moveStatus = false
        
        func close (){
            editStatus = false
            moveStatus = false
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
                case .count:
                    CountNode(node: node)
                case .subscribe:
                    SubscribeNode(node:node)
                default:
                    VStack{
                        NaggingNode(node: node)
                        HStack{
                            Text("全新节点请更新版本查看").card()
                            Spacer()
                        }
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
                    self.projectModel.initEditNode(node: node)
                    self.moveStatus = true
                }) {
                    Text("移动")
                }
                if(node.status == .complete || node.status == .expire){
                    Button(action: {
                        node.status = .progress
                        node.endTime = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
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
            .sheet(isPresented: $moveStatus, content: {
                NodeSort(state: self.$moveStatus, close: close)
            })
            .environmentObject(projectModel)
            .environmentObject(projectManageModel)
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
