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
    
    // 이번 달 첫 날 구하기
    func startOfCurrentMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번 달 마지막 날 구하기
//    func endOfCurrentMonth() -> Date {
//        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfCurrentMonth())!
//    }
    
    // 다음 달 첫 날 구하기
    func startOfNextMonth() -> DateComponents {
        let firstDayOfCurrentMonth = startOfCurrentMonth()
        let firstDayOfNextMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: firstDayOfCurrentMonth)!
        return Calendar.current.dateComponents([.year, .month, .day], from: firstDayOfNextMonth)
    }
    
    // 다음 달 첫날 <-> 현재 time interval 구하기
    func startDateOfNextMonth() -> TimeInterval {
        let firstDateOfNextMonth: DateComponents = self.startOfNextMonth()
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = firstDateOfNextMonth.year
        dateComponents.month = firstDateOfNextMonth.month
        dateComponents.day = firstDateOfNextMonth.day
        dateComponents.timeZone = TimeZone(abbreviation: "KST") // Japan Standard Time
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let userCalendar = Calendar(identifier: .gregorian)
        let startDateOfNextMonth = userCalendar.date(from: dateComponents)!
        
        let timeInterval = self.distance(to: startDateOfNextMonth)
        return timeInterval
    }
    
    // 인터벌 -> 타입으로 계산해주기
    func getIntervalTilLastDate() -> (DateIntervalType, Int) {
        let currentInterval = Int(self.startDateOfNextMonth())
        
        if currentInterval > dateInSec {
            return (.moreThanDay, Int(currentInterval / dateInSec))
        } else if hourInSec < currentInterval && currentInterval <= dateInSec {
            return (.betweenHourAndDay, currentInterval)
        } else {
            return (.lessThanHour, currentInterval)
        }
    }
}
