//
//  Int+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/27.
//

import Foundation

extension Int {
    var intToStringWithZero: String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}
