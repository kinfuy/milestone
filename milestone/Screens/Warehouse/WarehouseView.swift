//
//  Project.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI


extension WarehouseView {
    var NavHeader: some View {
        HStack(content: {
            Text("仓库")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
            Button(action: {
               
            }, label: {
                SFSymbol.plus
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
            })
        })
        .padding([.leading,.trailing])
    }
}

struct WarehouseView: View {
    
    var body: some View {
        VStack(content: {
            NavHeader
            Spacer()
        })

    }
}




struct Warehouse_Previews: PreviewProvider {
    static var previews: some View {
        ScreenManage()
    }
}
