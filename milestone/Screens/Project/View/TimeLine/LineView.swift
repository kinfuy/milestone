//
//  Line.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/30.
//

import SwiftUI


struct LineView: View {
    @State var width:CGFloat = 12
    @State var height:CGFloat = .infinity
    @State var color:Color = Color("BlueColor")
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width)
            .frame(minHeight: 70)
            .frame(maxHeight: height)
    }
}

#Preview {
    LineView()
}
