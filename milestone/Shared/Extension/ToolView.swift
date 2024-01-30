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

extension View {
    /// 当用户点击其他区域时隐藏软键盘
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createMenuItem(text: String, imgName: String, isDestructive: Bool = false, onAction: (() -> Void)?) -> some View {
        if #available(iOS 15.0, *) {
            return Button(role: isDestructive ? .destructive : nil) {
                onAction?()
            } label: {
                Label(text, systemImage: imgName)
            }
        } else {
            return Button {
                onAction?()
            } label: {
                Label(text, systemImage: imgName)
            }
        }
    }
    
    func createMenuItem(text: String, isDestructive: Bool = false, onAction: (() -> Void)?) -> some View {
        if #available(iOS 15.0, *) {
            return Button(role: isDestructive ? .destructive : nil) {
                onAction?()
            } label: {
                Text(text)
            }
        } else {
            return Button {
                onAction?()
            } label: {
                Text(text)
            }
        }
    }
}

extension String {
    /// 判断字符串是否是表情
    var isEmoji: Bool {
        let range = ClosedRange<UInt32>(uncheckedBounds: (0x1F000, 0x1F9FF))
        return unicodeScalars.contains(where: { scalar in scalar.value >= range.lowerBound && scalar.value <= range.upperBound })
    }
    /// MARK 加载国际化语言
    public func localized() -> String {
        let string = NSLocalizedString(self, comment: self)
        return string
    }
}
