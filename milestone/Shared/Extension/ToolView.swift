//
//  ToolView.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/10/6.
//

import SwiftUI
import Foundation
extension View {
    func lineTag(color:Color,font:Font = .caption)-> some View{
        self
            .font(font)
            .padding(.horizontal,6)
            .padding(.vertical,1)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
    
    func selection()->some View {
        self
            .padding()
            .background(Color("WriteColor"))
    }
    
    func card()-> some View {
        self
            .selection()
            .cornerRadius(12)
            .frame(height: 60)
    }
}

extension String {
    /// 判断字符串是否是表情
    ///
    /// - Returns: 字符串是否是表情
    var isEmoji: Bool {
        // 表情的 Unicode 范围为：
        // 0x1F000 - 0x1F9FF
        // 0x2600 - 0x27BF
        // 0x2700 - 0x27BF
        // 0x1F300 - 0x1F5FF
        // 0x1F600 - 0x1F6FF
        // 0x1F700 - 0x1F7FF
        // 0x1F800 - 0x1F8FF
        // 0x1F900 - 0x1F9FF
        
        let range = ClosedRange<UInt32>(uncheckedBounds: (0x1F000, 0x1F9FF))
        return unicodeScalars.contains(where: { scalar in scalar.value >= range.lowerBound && scalar.value <= range.upperBound })
    }
    
    //    var isEmoji: Bool {
    //        for scalar in unicodeScalars {
    //            if (0x1F600...0x1F64F ~= scalar.value) || (0x2702...0x27B0 ~= scalar.value) || (0x1F680...0x1F6FF ~= scalar.value) {
    //                return true
    //            }
    //        }
    //        return false
    //    }
}
