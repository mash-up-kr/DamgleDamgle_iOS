//
//  Story.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import Foundation

struct Stories: Decodable {
    let stories: [Story]
}

struct Story: Decodable, Hashable, Identifiable {
    let id: String
    let userNo: Int
    let nickname: String
    let x: Double
    let y: Double
    let content: String
    let reactions: [Reaction]
    let createdAt, updatedAt: Int
}
