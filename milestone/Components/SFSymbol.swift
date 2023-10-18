//
//  SFSymbol.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/16.
//

import SwiftUI

enum SFSymbol:String, Codable {
    case home = "calendar"
    case me = "person"
    case plus = "plus"
    case moon = "moon"
    case sun = "sun.max"
    case system = "cloud.sun"
    case message = "message"
    case like = "hand.thumbsup"
    case book = "book"
    case cloud = "cloud"
    case crown = "crown"
    case set = "gearshape"
    case time = "clock.arrow.2.circlepath"
    case walk = "figure.walk"
    case back = "chevron.backward"
    case ellipsis = "ellipsis"
    case flag = "flag.checkered"
    case clock = "clock"
    case tag = "tag"
    case close = "xmark"
    case delete = "trash"
    case warehouse = "books.vertical"
    case sunMin = "sun.min"
    case airplane = "airplane"
    case fossilShell = "fossil.shell"
}

extension SFSymbol: View {
    var body: Image {
        Image(systemName:rawValue)
    }
    func resizable() -> Image {
        self.body.resizable()
    }
    
    func renderingMode(renderingMode: Image.TemplateRenderingMode) -> Image {
        self.body.renderingMode(renderingMode)
    }
}
