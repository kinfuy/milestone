//
//  ProjectCard.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI

let MMDDHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日 HH:mm"
    return formatter
}()

let MMDD: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

let YYMMDDHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

//遵循Shape协议就可以画一个三角形
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()//路径
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}

extension ProjectView {
    struct ProjectCard: View {
        
        @EnvironmentObject var projectManageModel: ProjectManageModel
        
        var project:Project
        
        let OFFSET_VALUE:CGFloat = 140
        
        @GestureState var offset:CGFloat = 0
        
        @Binding var rightSliding: UUID?
        
        
        @Binding var sheetStatus:Bool
        
        var isOperate:Bool {
            project.id == rightSliding
        }
    
        var offsetX: CGFloat {

            if(isOperate){
                return -OFFSET_VALUE
            }
            return offset
        }
        
        var TopView: some View {
            project.isTop ? SFSymbol.unpin : SFSymbol.pin
        }
        
        @Binding var comfirm:Bool
        @Binding var deleteTips:String
        
        var body: some View {
            ZStack{
                HStack{
                    VStack{
                          Text(self.project.icon)
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                            .frame(width: 32,height: 32)
                            .padding(12)
                    }
                    .background(self.project.iconColor)
                    .cornerRadius(16)
                    .padding(.leading)
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(self.project.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.bottom, -4)
                            HStack{
                                ForEach(self.project.tags){ tag in
                                    tag.display()
                                }
                            }
                            .padding(.vertical,1)
                            Text(DateClass.compareCurrentTime(time: self.project.update))
                                .font(.caption)
                            
                        }
                        Spacer()
                    }
                    .padding(.leading,4)
                }
                .overlay(alignment: .topTrailing, content:   {
                    project.isTop ?
                    HStack(alignment: .top ,spacing: 0){
                        Spacer()
                        VStack(alignment: .leading, spacing: 0 ){
                            Triangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                            Spacer()
                        }
                    }
                    .offset(x: 0, y: -8)
                    : nil
                } )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color("WriteColor"))
                .cornerRadius(8)
                .padding(.vertical, 4)
                .offset(x: offsetX, y: 0)
                .animation(.spring, value: isOperate)
                .gesture(
                    DragGesture()
                        .updating($offset, body: {value,offset, _ in
                            if(value.translation.width < -OFFSET_VALUE ){
                                offset = -OFFSET_VALUE
                            }else{
                                offset = value.translation.width
                            }
                            
                            
                        })
                        .onEnded({ value in
                            let translaion = value.translation.width
                            if(translaion < -(OFFSET_VALUE * 0.4)){
                                self.rightSliding = self.project.id
                            }else {
                                self.rightSliding = nil
                            }
                        })
                )
                if(isOperate){
                    HStack{
                        Spacer()
                        VStack{
                            TopView
                            .foregroundColor(.white)
                                .padding(6)
                                .background(.gray)
                                .clipShape(Circle())
                            Text("置顶").font(.caption2).foregroundColor(.gray)
                        }
                        .onTapGesture {
                            projectManageModel.setTop(id: project.id, val: !project.isTop)
                            rightSliding = nil
                        }
                        .padding(.trailing, 4)
                        VStack{
                            SFSymbol.edit.foregroundColor(.white)
                                .padding(6)
                                .background(Color("BlueColor"))
                                .clipShape(Circle())
                            Text("编辑").font(.caption2).foregroundColor(.gray)
                        }
                        .onTapGesture {
                            projectManageModel.setCurrent(id: project.id)
                            sheetStatus.toggle()
                            rightSliding = nil
                        }
                        .padding(.trailing, 4)
                        VStack{
                            SFSymbol.delete.foregroundColor(.white)
                                .padding(6)
                                .background(.red)
                                .clipShape(Circle())
                            Text("删除").font(.caption2).foregroundColor(.gray)
                        }
                        .onTapGesture {
                            comfirm.toggle()
                            deleteTips = project.name
                        }
                  }
                }
            }
            
        }
    }
}

