//
//  EditProejct.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/11.
//

import SwiftUI
import MCEmojiPicker
import AlertToast

extension EditProejct {
    struct TitleView:View {
        var title:String
        var body: some View{
            HStack{
                Text(title).font(.headline).fontWeight(.bold).foregroundColor(Color.secondary)
                Spacer()
            }
        }
    }
    
    struct TagManageView: View {
        @EnvironmentObject var tagManage:TagManageModel
        @State var isEdit:Bool = false
        var body: some View{
            HStack{
                VStack{
                    TagListView(isEdit: self.$isEdit)
                }
                Spacer()
                VStack{
                    HStack{
                        Group{
                            if(isEdit){
                                Text("全部删除")
                                    .onTapGesture {
                                        self.tagManage.removeAll()
                                        self.isEdit.toggle()
                                    }
                                Text("完成")
                                    .onTapGesture {
                                        self.isEdit.toggle()
                                    }
                            }else{
                                SFSymbol.delete
                                    .onTapGesture {
                                        self.isEdit.toggle()
                                    }
                            }
                        }
                        .font(.subheadline)
                        .padding(.top, 4)
                        .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }
    }
    
    var NavView:some View {
        HStack{
            Button("取消", action: {
                self.$state.wrappedValue.toggle()
            })
            Spacer()
            Text(projectModel.isEdit ? "编辑项目" : "新建项目").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Spacer()
            Button("完成", action: {
                if(self.validate()){
                    self.projectModel.project?.name = self.name
                    self.projectModel.project?.icon = self.emoji
                    self.projectModel.project?.iconColor = self.projectColor
                    self.projectModel.project?.tags = self.tagManage.tags
                    if(projectModel.isEdit){
                        projectManageModel.update(project: self.projectModel.project!)
                    }else{
                        projectManageModel.add(project: self.projectModel.project!)
                    }
                    
                    self.$state.wrappedValue.toggle()
                }
                else {
                    showToast = true
                }
            })
        }
        .padding(.vertical)
    }
    
    var NameView:some View{
        VStack{
            TitleView(title:"项目名称")
            VStack{
                HStack{
                    VStack{
                        Spacer()
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Text(emoji).font(.largeTitle)
                        }).emojiPicker(
                            isPresented: $isPresented,
                            selectedEmoji: $emoji
                        )
                            .frame(width: 48,height: 48)
                            .padding(8)
                            .background(self.projectColor)
                            .cornerRadius(16)
                        Spacer()
                    }
                    TextField("名字是事物有意义的开始", text: $name)
                    ColorPicker("", selection: self.$projectColor)
                        .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                }
            }
            .padding()
            .frame(height: 120)
            .background(Color("WriteColor"))
            .cornerRadius(12)
        }
        .padding(.bottom)
    }
    
    var TagView:some View {
        VStack{
            TitleView(title:"项目标签")
            VStack{
                if(self.tagManage.tags.count<8){
                    HStack{
                        ColorPicker("", selection: self.$tagColor)
                            .pickerStyle(InlinePickerStyle())
                            .labelsHidden()
                        Spacer()
                        Text("标签色").foregroundColor(.gray)
                    }
                    
                    Divider()
                    HStack{
                        TextField(text: self.$inputTag, label: {
                            Text("#")
                        }).onChange(of: self.inputTag){
                            newValue in
                            if(newValue.count>4){
                                self.inputTag = String(newValue.suffix(4))
                            }
                        }
                        
                        if(self.inputTag != ""){
                            SFSymbol.plus
                                .onTapGesture {
                                    self.tagManage.add(tag: Tag(title: self.inputTag, color: self.tagColor,create:Date(),update:Date()))
                                    self.inputTag = ""
                                }
                        }else{
                            SFSymbol.tag
                                .padding(.trailing, 3)
                        }
                    }
                    .frame(height: 40)
                   
                }
                
                if(self.tagManage.tags.count>0){
                    if(self.tagManage.tags.count<4){
                        Divider()
                    }
                    TagManageView()
                        .environmentObject(tagManage)
                }
            }
            .padding()
            .background(Color("WriteColor"))
            .cornerRadius(12)
        }
    }
    
    var TempView:some View {
        VStack{
            TitleView(title:"项目模板")
            
        }
    }
}

struct EditProejct: View {
    @EnvironmentObject var projectManageModel: ProjectManageModel
    @Binding var state:Bool
    
    @StateObject private var projectModel: ProjectModel = ProjectModel()
    @StateObject private var tagManage:TagManageModel = TagManageModel(tags: [])
    
    @State private var name:String=""
    @State private var emoji:String = "📖"
    @State private var inputTag:String = ""
    @State private var projectColor = Color("GreenColor")
    @State private var tagColor = Color("BlueColor")
    
    @State private var isPresented = false
    @State private var showToast = false
    
    
    
    func validate()-> Bool {
        if(self.name == "" ) {
            return false
        }
        if(self.emoji == "" ){
            return false
        }
        return true
    }
    


    var body: some View {
        ZStack{
            BgView()
            VStack{
                if((projectModel.project) != nil){
                    NavView
                    ScrollView(content: {
                        NameView
                        TagView
                    })
                }else{
                    Text("暂无数据")
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .toast(isPresenting: $showToast,offsetY: 30){
            AlertToast(displayMode: .hud, type: .error(.red), title: "请完善项目信息")
        }
        .onAppear {
            if (projectModel.project == nil) {
                projectModel.initProject(project: projectManageModel.currentProject)
                if let project = projectModel.project {
                    self.name = project.name
                    self.emoji = project.icon
                    self.projectColor = project.iconColor
                    self.tagManage.add(tags: project.tags)
                }
            }
        }
    }
}



