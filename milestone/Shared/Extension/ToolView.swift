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


extension Date {
    func compareTo(otherDate: Date) -> String {
        let seconds = abs(self.timeIntervalSince(otherDate))
        let days = Double(seconds / 60 / 60 / 24)
        if days < 1 {
            return describeTimeComponent(Calendar.current.dateComponents([.hour, .minute], from: self, to: otherDate))
        } else if days < 8 {
            let numDays = Int(days.rounded())
            switch numDays {
            case 1:
                return "昨日"
            case 2...3:
                return "\(numDays) 天前"
            default:
                return "\(numDays) 天前"
            }
        } else {
            let months = days / 30.4375
            let remainder = days.truncatingRemainder(dividingBy: 30.4375)
            
            if remainder == 0 {
                return "\(Int(months)) month\(Int(months) > 1 ? "s" : "") ago"
            } else {
                return self.description
            }
        }
    }

    fileprivate func describeTimeComponent(_ timeComponent: DateComponents) -> String {
        guard let hours = timeComponent.hour, let minutes = timeComponent.minute else {
            return "刚刚"
        }
        if minutes < 10 || hours == 1 && minutes < 50 {
            return "1 小时前"
        } else if hours == 1 && minutes >= 50 {
            return "2 小时前"
        } else {
            return "\(hours) hours and \(minutes) minutes ago"
        }
    }
}
