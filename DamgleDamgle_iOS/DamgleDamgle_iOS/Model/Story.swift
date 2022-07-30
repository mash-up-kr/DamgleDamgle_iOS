//
//  Story.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import Foundation

struct Storeies: Decodable {
    let stories: [Story]
}

struct Story: Decodable, Hashable, Identifiable {
    let id: String
    let userNo: Int
    let nickname: String
    let x: Int
    let y: Int
    let content: String
    let reactions: [Reaction]
    let createdAt, updatedAt: Int
}
