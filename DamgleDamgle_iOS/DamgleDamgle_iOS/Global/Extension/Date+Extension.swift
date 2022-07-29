//
//  Date+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/24.
//

import Foundation

extension Date {
    var dateInSec: Int {
        24 * 60 * 60
    }
    
    var hourInSec: Int {
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
    
    func getDateIntervalType() -> (DateIntervalType, Int) {
        let currentInterval = Int(distance(to: startOfNextMonth()))
        
        if currentInterval > dateInSec {
            return (.moreThanDay, Int(currentInterval / dateInSec))
        } else if hourInSec < currentInterval && currentInterval <= dateInSec {
            return (.betweenHourAndDay, currentInterval)
        } else {
            return (.lessThanHour, currentInterval)
        }
    }
}
