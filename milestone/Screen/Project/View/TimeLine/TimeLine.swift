//
//  TimeLine.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/19.
//

import SwiftUI
import Foundation;


struct TimeLineView: View {
    @Binding var timeLines:[TimeLine]
    @Binding var current:Int
    
    @GestureState var offset:CGFloat = 0
    
    var timeLine:TimeLine {
        timeLines[current]
    }
    
    var total:Int {
        timeLines.count
    }
    
    var isStart:Bool {
        return self.current == 0
    }
    var isEnd: Bool {
        return self.current == self.total - 1
    }
    
    func switchTab(type: String){
        let idx =  type == "last" ? -1 : 1
        if(self.current + idx > self.total - 1){
            self.current  = self.total - 1
        }else if(self.current + idx < 0) {
            self.current  =  0
        }
        else{
            self.current = self.current + idx
        }
    }
    
    func currentWidth(width:CGFloat) -> CGFloat {
        if(self.total == 1) { return width }
        return abs(width - 40)
    }
    
    
    func offsetFor(index:Int, width:CGFloat)-> CGFloat{
        if(self.total == 1) { return 0}
        let idx =  self.offsetIndex(index: index)
        var offsetWidth = 0
        if(self.isEnd){
            if(self.current == index){
                offsetWidth = 40
            }else{
                offsetWidth = 100
            }
           
        }
        if(self.isStart) {
            if(self.current != index){
                offsetWidth = -60
            }
        }
        if(!self.isEnd && !self.isStart && idx>0){
            offsetWidth = -60
        }
        return width  * CGFloat(idx) + CGFloat(offsetWidth) + self.offset
    }
    
    
    func offsetIndex(index:Int)->Int{
        return index - self.current;
    }

    
    var body:some View {
        GeometryReader(content: { geometry in
            ZStack{
                VStack(spacing: 10){
                    HStack{
                        ZStack{
                            ForEach(Array(timeLines.enumerated()), id: \.element.id) { index,line in
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
                                                                Text(timeLine.milestone[0].label)
                                                                Text(":")
                                                            }.foregroundColor(.gray)
                                                            Text(timeLine.milestone[0].display())
                                                                .foregroundColor(Color("GreenColor"))
                                                            if((timeLine.milestone[0].unit) != nil){
                                                                Text("\(timeLine.milestone[0].unit!)")
                                                                    .foregroundColor(.gray)
                                                                    .font(.caption)
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                            line.icon.resizable().scaledToFit()
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
                                    switchTab(type: "last")
                                }else {
                                    switchTab(type: "next")
                                }
                            })
                    )
                    .frame(width: geometry.size.width, height: 100)
                    ScrollView(content: {
                        VStack(alignment: .leading,spacing: 0){
                            Text("2023")
                                .font(.title3)
                                .foregroundColor(Color("BlueColor"))
                                .fontWeight(.bold)
                            ForEach(timeLine.nodes) { node in
                                LineNodeView(node: node)
                            }
                        }
                        .padding(.horizontal)
                    })
                }
                VStack{
                    Spacer()
                    VStack{
                        SFSymbol.plus.resizable()
                            .scaledToFit()
                            .frame(width: 24,height: 24)
                            .foregroundColor(Color("WriteColor"))
                    }
                    .padding(16)
                    .background(Color("BlueColor"))
                    .clipShape(Circle())
                    
                }
            }
        })
        
    }
    
    
}

//#Preview {
//    TimeLineView()
//}

