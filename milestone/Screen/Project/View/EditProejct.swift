//
//  EditProejct.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/11.
//

import SwiftUI


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
        @Binding var tagList:[Tag]
        @State var isEdit:Bool = false
        var body: some View{
            HStack{
                VStack{
                    TagListView(tags: self.$tagList,isEdit: self.$isEdit)
                        .frame(minHeight: 30)
                }
                Spacer()
                VStack{
                    HStack{
                        Group{
                            if(isEdit){
                                Text("全部删除")
                                    .onTapGesture {
                                        self.tagList = []
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
}

struct EditProejct: View {
    @Binding var state:Bool
    @State var name:String = ""
    @State var emoji:String = "📖"
    @State var inputTag:String = ""
    @State var projectColor = Color("GreenColor")
    @State var tagColor = Color("BlueColor")
    @State var tagList:[Tag] = []
    var body: some View {
        ZStack{
            BgView()
            VStack{
                HStack{
                    Button("取消", action: {
                        self.$state.wrappedValue.toggle()
                    })
                    Spacer()
                    Text("新建项目").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Button("完成", action: {
                        self.$state.wrappedValue.toggle()
                    })
                }
                .padding(.vertical)
                VStack{
                    TitleView(title:"项目名称")
                    VStack{
                        HStack{
                            VStack{
                                Spacer()
                                EmojiTextField(text: self.$emoji,size: 42)
                                    .onChange(of: self.emoji){
                                        newValue in
                                        if(newValue.count>1){
                                            self.emoji = String(newValue.suffix(1))
                                        }
                                        if(!self.emoji.isEmoji){
                                            self.emoji = "📖"
                                        }
                                    }
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
                VStack{
                    TitleView(title:"项目标签")
                    VStack{
                        if(self.tagList.count<4){
                            HStack{
                                ColorPicker("", selection: self.$tagColor)
                                    .pickerStyle(InlinePickerStyle())
                                    .labelsHidden()
                                Spacer()
                                Text("标签色").foregroundColor(.gray)
                            }
                            
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .frame(width: .infinity, height: 1)
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
                                            self.$tagList.wrappedValue
                                                .append(
                                                    Tag(title: self.inputTag, color: self.tagColor)
                                                )
                                            self.inputTag = ""
                                        }
                                }else{
                                    SFSymbol.tag
                                        .padding(.trailing, 3)
                                }
                            }
                            .frame(height: 40)
                           
                        }
                        
                        if(tagList.count>0){
                            if(self.tagList.count<4){
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: .infinity, height: 1)
                            }
                            TagManageView(tagList: self.$tagList)
                        }
                        
                        
                        
                    }
                    .padding()
                    .frame(minHeight: 50)
                    .background(Color("WriteColor"))
                    .cornerRadius(12)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}



struct EditProejct_Previews: PreviewProvider {
    @State static var state:Bool = true
    static var previews: some View {
        EditProejct(state: $state)
    }
}

