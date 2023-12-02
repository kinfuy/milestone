//
//  CardSelectView.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/19.
//

import SwiftUI


extension CardSelectView {
    var NavView:some View {
        VStack{
            Rectangle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 50,height: 4)
                .cornerRadius(4)
                .padding(.top,8)
        }
    }
    struct Cardview:View {
        var icon:SFSymbol
        var title:String
        var desc:String
        var body: some View{
            VStack{
                HStack{
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                        .foregroundColor(Color("GreenColor"))
                    VStack(alignment: .leading){
                        Text(title)
                        Text(desc)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
            }.card()
        }
        
    }
}

extension CardSelectView {
    var NodeContentView:some View {
        VStack{
            SecondTitleView(title: "节点树").foregroundColor(.secondary)
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(NodeType.list, id: \.rawValue, content: { item in
                    Cardview(icon: item.icon, title: item.text, desc: item.desc)
                        .onTapGesture {
                            self.projectModel.initEditNode(type: item)
                            self.lineEditState.toggle()
                        }
                })
                .sheet(isPresented: self.$lineEditState){
                    EditNode(
                        state: self.$lineEditState,
                        close: close
                    )
                    .onDisappear(){
                        self.selected = nil
                    }
                }
                .environmentObject(projectModel)
            }
           
          
        }
        .padding(.horizontal)
    }
}

extension CardSelectView {
    struct NormalLineView:View{
        @EnvironmentObject var projectModel: ProjectModel
        @Binding var state:Bool
        @State var isEdit:Bool = false
        
        func close(){
            isEdit.toggle()
            state.toggle()
        }
        var body: some View{
            HStack{
                SFSymbol.time
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                    .foregroundColor(Color("GreenColor"))
                Text("时间线")
                Spacer()
            }
            .card()
            .onTapGesture {
                self.projectModel.initEditTimeline()
                self.isEdit.toggle()
            }
            .sheet(isPresented: self.$isEdit){
                EditTimeLine(
                    state: self.$isEdit,
                    close: close
                )
            }
            .environmentObject(projectModel)
        }
    }
    struct CustomeView:View{
        var body: some View{
            HStack{
                SFSymbol.shuffle
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                    .foregroundColor(Color("GreenColor"))
                Text("自定义时间线")
                Spacer()
            }
            .card()
        }
    }
}

struct CardSelectView:View {
    @EnvironmentObject var projectModel: ProjectModel
    @Binding var state:Bool
    @State var lineEditState:Bool = false
    @State private var selected:NodeType?
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    func close (){
        self.state.toggle()
    }
    var body: some View {
        ZStack{
            BgView()
            VStack{
                NavView
                if(!self.projectModel.timeLines.isEmpty){
                    NodeContentView
                }
                VStack{
                    SecondTitleView(title: "时间线").foregroundColor(.secondary)
                    VStack{
                        NormalLineView(state: self.$state)
//                        CustomeView()
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}


