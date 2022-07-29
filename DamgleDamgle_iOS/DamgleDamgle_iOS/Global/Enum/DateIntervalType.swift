//
//  DateIntervalType.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/27.
//

import UIKit

enum DateIntervalType {
    case moreThanDay
    case betweenHourAndDay
    case lessThanHour
    
    var backgroundColor: UIColor {
        switch self {
        case .moreThanDay, .betweenHourAndDay:
            return UIColor(named: "grey1000") ?? .systemGray
        case .lessThanHour:
            return UIColor(named: "orange500") ?? .systemGray
        }
    }
}
