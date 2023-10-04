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
            VStack{
                node.type.icon
            }
            .padding(4)
            .foregroundColor(Color("GreenColor"))
            .background(Color("WriteColor"))
            .cornerRadius(8)
            .offset(x: -24)
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text(node.text)
                    Text(dateFormatter.string(from: node.createTime))
                         .font(.caption)
                }
            }
            .offset(x: -20)
        }
    }
    
    struct TaskNode: View {
        @State var node:LineNode
        var body:some View {
            VStack{
                node.type.icon
            }
            .padding(4)
            .foregroundColor(Color("GreenColor"))
            .background(Color("WriteColor"))
            .cornerRadius(8)
            .offset(x: -24)
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text(node.text)
                    Text(dateFormatter.string(from: node.createTime))
                         .font(.caption)
                    Text("剩余82天")
                        .font(.caption)
                        .padding(.horizontal,6)
                        .padding(.vertical,1)
                        .background(Color("SuccessColor"))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                   
                }
            }
            .offset(x: -20)
        }
    }
    
    struct MilestoneNode:View {
        @State var node:LineNode
        var body:some View {
            GeometryReader(content: { geometry in
                HStack{
                    VStack(alignment: .leading){
                        Text(node.text)
                        Text(dateFormatter.string(from: node.createTime))
                             .font(.caption)
                    }
                    Spacer()
                    HStack{
                        node.type.icon.foregroundColor(Color("GreenColor"))
                            .padding(.trailing,10)
                        SFSymbol.ellipsis
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(width: geometry.size.width)
                .background(Color("WriteColor"))
                .cornerRadius(8)
                .padding(.top,10)
               
                
            })
            
        }
    }
    
    struct NodeView:View {
        @State var node:LineNode
        var body: some View {
            HStack{
                switch node.type {
                case .milestone:
                    MilestoneNode(node: node)
                case .nagging:
                    NaggingNode(node: node)
                case .task:
                    TaskNode(node: node)
                }
            }
        }
    }
}




struct LineNodeView: View {
    @State var lineType:NodeType = .nagging
    @State var node:LineNode
    var body: some View {
        HStack{
            HStack{
                LineView(width: 4)
                NodeView(node: node)
            }
            .padding(.leading, 20)
            Spacer()
        }
    }
}

//#Preview {
//    LineNodeView()
//}
