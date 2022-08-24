//
//  StoryResponse.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/20.
//

import Foundation

// MARK: - StoryFeed
struct StoryFeed: Decodable {
    let stories: [Story]
    let size: Int
}
