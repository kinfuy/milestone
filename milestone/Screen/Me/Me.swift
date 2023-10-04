//
//  Me.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI

enum DarkMode: String, CaseIterable {
    case light = "浅色"
    case dark = "深色"
    case system = "系统"
    
    var mode:ColorScheme {
        switch self {
        case .dark:
            return ColorScheme.dark
            
        case .light:
            return ColorScheme.light
        case .system:
            return ColorScheme.light
        }
    }
    var text: String {
        switch self {
        case .dark:
            return "深色"
            
        case .light:
            return "浅色"
        case .system:
            return "跟随系统"
        }
        
    }
}

extension Me {
    var NavHeader: some View {
        HStack(content: {
            Text("设置")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
        })
        .padding([.leading,.trailing])
    }
}

extension View {
    func labelWithIcon(color:Color)-> some View{
        self
        .frame(width: 30,height: 30)
        .padding(4)
        .background(color)
        .foregroundColor(Color.white)
        .cornerRadius(8)
        .padding(.trailing,4)
    }
    
}

struct Me: View {
    @AppStorage("DarkMode") var darkMode:DarkMode = .system
    @State var isSynciCloud = false
    @State var isPro = true
    var body: some View {
        VStack{
            NavHeader
            List(content: {
                Section(content: {
                    VStack(alignment: .leading){
                        HStack{
                            Text("里程碑").font(.title2)
                            Text("Pro")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.purple)
                                .frame(width: 40,height: 32)
                                .background(Color.purple.opacity(0.3))
                                .cornerRadius(10)
                            Spacer()
                        }
                        VStack(alignment:.leading){
                            Text("升级Pro版本享受所有功能")
                                .foregroundColor(Color.gray)
                            Text("点击查看详情")
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    }
                    .padding(.vertical,15)
                    .frame(height: 88)
                    
                })
                .listRowSeparator(.hidden)
                Section("基础设置", content: {
                    Picker(selection: $darkMode, content: {
                        ForEach(DarkMode.allCases, id:\.rawValue){item in
                            Text(item.text).tag(item)
                        }
                    }, label: {
                        HStack{
                            VStack{
                                switch darkMode {
                                case .dark: SFSymbol.moon.labelWithIcon(color: Color.black)
                                case .light: SFSymbol.sun.labelWithIcon(color: Color.mint)
                                case .system: SFSymbol.system.labelWithIcon(color: Color.gray)
                                }
                            }
                            
                            Text("外观模式")
                        }
                    })
                    .pickerStyle(.menu)
                    Toggle(isOn: $isSynciCloud, label: {
                        HStack{
                           SFSymbol.cloud
                                .labelWithIcon(color: Color.cyan)
                           Text("数据同步iCloud")
                        }
                    })

                })
                .listRowSeparator(.hidden)
                Section("关于我们",content:   {
                    HStack{
                        SFSymbol.book.labelWithIcon(color: Color.gray)
                       Text("帮助与指南")
                    }
                    HStack{
                       SFSymbol.message.labelWithIcon(color: Color.green)
                       Text("联系作者")
                    }
                    HStack{
                        SFSymbol.like.labelWithIcon(color: Color.yellow)
                       Text("给个好评")
                    }
                })
                .listRowSeparator(.hidden)
            })
            .listStyle(.plain)
            .cornerRadius(24)
            .padding(.horizontal, 24)
            .background(Color.clear)
            Spacer()
        }
    }
}

struct Me_Previews: PreviewProvider {
    static var previews: some View {
        Me()
    }
}
