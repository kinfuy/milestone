//
//  InitView.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/24.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            VStack{
                Spacer()
                ZStack{
                    HStack{
                        Rectangle()
                            .fill(Color("BlueColor").opacity(0.2))
                            .rotationEffect(Angle.init(degrees: 54))
                            .offset(CGSize(width: 20, height: -80))
                            .frame(width: 40)
                        Rectangle()
                            .fill(Color("PinkColor").opacity(0.2))
                            .rotationEffect(Angle.init(degrees: 54))
                            .frame(width: 40)
                        Rectangle()
                            .fill(Color("GreenColor").opacity(0.2))
                            .offset(CGSize(width: 50, height: 80))
                            .rotationEffect(Angle.init(degrees: 54))
                            .frame(width: 40)
                    }
                    .offset(CGSize(width: 0, height: 100))
                    VStack(alignment: .trailing){
                        HStack(alignment: .bottom,spacing: 0){
                            Group{
                                VStack(alignment: .leading){
                                    Text("行动").font(.system(size: 48))
                                    Text("不拘泥").font(.system(size: 48))
                                }
                                Image("start")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 88,height: 220)
                                Text("计划").font(.system(size: 48))
                            }
                            .foregroundColor(Color("BlueColor"))
                        }
                        VStack{
                            Text("Plan Less Do More")
                                .font(.system(size: 28))
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                        
                    }
                    .offset(CGSize(width: 0, height: -60))
                    
                }
                VStack{
                    Image("logo-text")
                        .padding(.bottom, 30)
                }
            }.frame(width: geometry.size.width,height: geometry.size.height)
        })
       
    }
}

#Preview {
    LaunchView()
}
