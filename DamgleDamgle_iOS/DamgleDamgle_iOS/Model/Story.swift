//
//  Story.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import Foundation

struct Stories: Decodable {
    var stories: [Story]
    let size: Int
}

struct Story: Decodable, Hashable, Identifiable {
    let id: String
    let userNo: Int
    let nickname: String
    var address1: String?
    var address2: String?
    let isMine: Bool
    let x: Double
    let y: Double
    let content: String
    let reactions: [Reaction]
    let reactionSummary: [ReactionSummary]
    let reactionOfMine: MyReaction?
    let reports: [Report]
    let createdAt, updatedAt: Int

    var secCreateAt: Double {
        return Double(createdAt) / 1000
    }

    var secUpdatedAt: Double {
        return Double(updatedAt) / 1000
    }
    
    var mostReaction: String {
        var mostCount: Int = 0
        var mostReaction: String = ""
        
        reactionSummary.forEach { reaction in
            if reaction.count > mostCount {
                mostCount = reaction.count
                mostReaction = reaction.type
            }
        }
        return mostReaction
    }
    
    var offsetTimeText: String {
        let offsetTime = Calendar.current.dateComponents([.year,.month,.weekday,.day,.hour,.minute, .second], from: secCreateAt.toDate ?? Date(), to: Date())

        let year = offsetTime.year ?? 0
        let month = offsetTime.month ?? 0
        let week = Int((offsetTime.day ?? 0) / 7)
        let day = (offsetTime.day ?? 0) % 7
        let hour = offsetTime.hour ?? 0
        let minute = offsetTime.minute ?? 0
        let second = offsetTime.second ?? 0

        if year != 0 {
            return "\(year)년 전"
        } else if month != 0 {
            return "\(month)달 전"
        } else if week != 0 {
            return "\(week)주 전"
        } else if day != 0 {
            return "\(day)일 전"
        } else if hour != 0 {
            return "\(hour)시간 전"
        } else if minute != 0 {
            return "\(minute)분 전"
        } else {
            return "\(second)초 전"
        }
    }
    
    var reactionAllCount: Int {
        var allCount = 0
        for reaction in reactionSummary {
            allCount += reaction.count
        }
        return allCount
    }
}
