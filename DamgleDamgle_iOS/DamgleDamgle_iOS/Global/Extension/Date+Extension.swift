//
//  Date+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/24.
//

import Foundation

extension Date {
    static var dateInSec: Int {
        24 * 60 * 60
    }
    
    static var hourInSec: Int {
        60
    }

    private func startOfCurrentMonth() -> Date {
        let currentMonthComponent = Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: currentMonthComponent)!
    }
    
    private func startOfNextMonth() -> Date {
        let nextMonthInDate = Calendar.current.date(byAdding: DateComponents(month: 1), to: startOfCurrentMonth())!
        let startOfNextMonth = Calendar.current.startOfDay(for: nextMonthInDate)
        return startOfNextMonth
    }
    
    func getDateIntervalType() -> (type: DateIntervalType, value: Int) {
        let currentInterval = Int(distance(to: startOfNextMonth()))
        
        if currentInterval > Date.dateInSec {
            return (type: .moreThanDay, value: Int(currentInterval / Date.dateInSec))
        } else if Date.hourInSec < currentInterval && currentInterval <= Date.dateInSec {
            return (type:.betweenHourAndDay, value: currentInterval)
        } else {
            return (type:.lessThanHour, value: currentInterval)
        }
    }
}
