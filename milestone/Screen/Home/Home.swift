//
//  Home.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI


struct TitleView:  View {
    var title:String = ""
    var body: some View {
        HStack(content: {
            Text(title).font(.title2)
            Spacer()
            
        }).padding(.horizontal, 24)
    }
}


extension Home {
    var NavHeader: some View {
        HStack(content: {
            Text("今日摘要")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
        })
        .padding([.leading,.trailing])
    }
    var ActiveHopeView: some View {
        HStack{
            Text("种一颗树最好的时间是十年前，其次是现在")
                .font(.headline)
                .foregroundColor(Color.accentColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
        
    }
}

struct Home: View {
    var body: some View {
        NavHeader
        ActiveHopeView
        TitleView(title: "最近任务")
        Spacer()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ScreenManage()
    }
}
