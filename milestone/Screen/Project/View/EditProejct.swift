//
//  EditProejct.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/11.
//

import SwiftUI

struct EditProejct: View {
    @Binding var state:Bool
    @State var name:String = ""
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
                    HStack{
                        Text("项目名称").font(.headline).fontWeight(.bold).foregroundColor(Color.secondary)
                        Spacer()
                    }
                    HStack{
                        ZStack{
                            EmojiTextField(text: self.$name)
                            VStack{
                                SFSymbol.book.font(.title2).foregroundColor(Color("WriteColor"))
                            }
                            .padding(16)
                            .background(Color("GreenColor"))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                        
                    }
                    .padding()
                    .frame(height: 80)
                    .background(Color("WriteColor"))
                    .cornerRadius(12)
                }
                HStack{
                    
                }
                Spacer()
            }
            .padding()
        }
       
    }
}



