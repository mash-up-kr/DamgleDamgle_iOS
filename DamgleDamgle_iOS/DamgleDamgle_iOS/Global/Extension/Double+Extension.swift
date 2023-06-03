//
//  Double+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/09.
//

import Foundation

extension Double {
    var toDate: Date? {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
    }
}
