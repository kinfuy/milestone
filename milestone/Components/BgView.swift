//
//  BgView.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/4.
//

import SwiftUI

struct BgView: View {
    var body: some View {
        LinearGradient(gradient: Gradient( colors: [
            Color.accentColor.opacity(0.05),
            Color.gray.opacity(0.1)
        ]),startPoint: .top,endPoint: .bottom)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
