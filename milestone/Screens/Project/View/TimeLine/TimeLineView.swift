//
//  TimeLine.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/19.
//

import SwiftUI
import Foundation;





extension TimeLineView {
    var AddView:some View {
        VStack{
            Spacer()
            VStack{
                SFSymbol.plus.resizable()
                    .scaledToFit()
                    .frame(width: 24,height: 24)
                    .foregroundColor(Color("WriteColor"))
                    .onTapGesture {
                        self.sheetStatus.toggle()
                    }
                
            }
            .sheet(isPresented: self.$sheetStatus, content:   {
                CardSelectView(state: self.$sheetStatus)
            })
            .environmentObject(projectModel)
            
            .padding(16)
            .background(Color("BlueColor"))
            .clipShape(Circle())
            
        }
    }
    
    var LineContentView: some View {
        VStack(alignment: .leading,spacing: 0){
            if(projectModel.timeLine != nil && projectModel.timeLine!.isHasNodes){
                if(project.sort == .asc){
                    Text("2023")
                    .font(.title3).fontWeight(.bold)
                    .foregroundColor(Color("BlueColor"))
                    .padding(.horizontal)
                }
                ScrollView(content: {
                    VStack(alignment: .leading, spacing: 0){
                        ForEach(projectModel.timeLine!.nodes,id:\.self) { node in LineNodeView(node: node )
                        }
                    }
                    .padding(.horizontal)
                })
                .environmentObject(projectModel)
            }
            
        }
    }
}


struct TimeLineView: View {
    @EnvironmentObject var projectManageModel: ProjectManageModel
    @EnvironmentObject var projectModel: ProjectModel
    @State var project: Project
    
    @GestureState var offset:CGFloat = 0
    @State var sheetStatus = false
    
    @State var timelineEdit = false
    
    func currentWidth(width:CGFloat) -> CGFloat {
        if(projectModel.total == 1) { return width }
        return abs(width - 40)
    }
    
    
    func offsetFor(index:Int, width:CGFloat)-> CGFloat{
        if(projectModel.total == 1) { return 0}
        let idx =  self.offsetIndex(index: index)
        var offsetWidth = 0
        if(projectModel.isEnd){
            if(projectModel.currentIndex == index){
                offsetWidth = 40
            }else{
                offsetWidth = 100
            }
            
        }
        if(projectModel.isStart) {
            if(projectModel.currentIndex != index){
                offsetWidth = -60
            }
        }
        if(!projectModel.isEnd && !projectModel.isStart && idx>0){
            offsetWidth = -60
        }
        return width  * CGFloat(idx) + CGFloat(offsetWidth) + self.offset
    }
    
    
    func offsetIndex(index:Int)->Int{
        return index - projectModel.currentIndex;
    }

    
    func close() {
        self.timelineEdit = false
    }
    
    var body:some View {
        GeometryReader(content: { geometry in
            ZStack{
                VStack(spacing: 10){
                    HStack{
                        ZStack{
                            ForEach(Array(projectModel.timeLines.enumerated()), id: \.element.id) { index,line in
                                VStack{
                                    GeometryReader(content: { tab in
                                        Spacer()
                                        HStack{
                                            VStack(alignment: .leading){
                                                Text(line.name)
                                                    .font(.title3)
                                                if(line.milestone.count>0){
                                                    VStack{
                                                        HStack(alignment:.bottom){
                                                            Group{
                                                                Text(line.milestone[0].label)
                                                                Text(":")
                                                            }.foregroundColor(.gray)
                                                            Text(line.milestone[0].display())
                                                                .foregroundColor(Color("GreenColor"))
                                                            Text(line.milestone[0].unit ?? "")
                                                                .foregroundColor(.gray)
                                                                .font(.caption)
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                            line.icon.display()
                                                .frame(width: 24,height: 24)
                                                .foregroundColor(Color("BlueColor"))
                                            
                                        }
                                        .padding()
                                        .frame(
                                            width: currentWidth(width: tab.size.width),
                                            height: tab.size.height
                                        )
                                        .background(Color("WriteColor"))
                                        .cornerRadius(8)
                                        .contextMenu(menuItems: {
                                            Button(action: {
                                                self.timelineEdit=true
                                                self.projectModel.initEditTimeline(line: line)
                                            }) {
                                                Text("编辑")
                                            }
                                            Button(action: {
                                                self.projectModel.deleteTimeline(id: line.id)
                                            }) {
                                                Text("删除")
                                            }
                                        })
                                        .sheet(isPresented: self.$timelineEdit){
                                            EditTimeLine(
                                                state: self.$timelineEdit,
                                                close: close
                                            )
                                        }
                                        .environmentObject(projectModel)
                                        
                                        .shadow(
                                            color:
                                                Color("BlueColor")
                                                .opacity(0.2), radius: 4, x: 4, y:4)
                                        .opacity(1 - abs(CGFloat(offsetIndex(index:index)) * 0.25) )
                                        .scaleEffect(1 - abs(CGFloat(offsetIndex(index:index)) * 0.05))
                                        .offset(x: offsetFor(index: index, width: geometry.size.width))
                                        
                                    })
                                    
                                }
                                .padding()
                                
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: offset == 0 )
                    .gesture(
                        DragGesture()
                            .updating($offset, body: {value,out, _ in
                                out = (value.translation.width / geometry.size.width) * geometry.size.width * 1
                            })
                            .onEnded({ value in
                                let translaion = value.translation.width
                                if(translaion>0){
                                    // right
                                    projectModel.switchTab(type: "last")
                                }else {
                                    projectModel.switchTab(type: "next")
                                }
                            })
                    )
                    .frame(width: geometry.size.width, height: 100)
                    if(projectModel.total > 0 ){
                        LineContentView
                    }
                    Spacer()
                    
                }
                AddView
            }
        })
    }
    
    
}


