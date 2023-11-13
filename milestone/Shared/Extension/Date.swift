//
//  Date.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/11/5.
//

import Foundation

extension Date {
    func year() -> Int {
        Calendar.current.component(.era, from: self)
    }

    func month() -> Int {
        Calendar.current.component(.month, from: self)
    }

    func day() -> Int {
        Calendar.current.component(.day, from: self)
    }

    func hour() -> Int {
        Calendar.current.component(.hour, from: self)
    }

    func minute() -> Int {
        Calendar.current.component(.minute, from: self)
    }

    func second() -> Int {
        Calendar.current.component(.second, from: self)
    }
}
