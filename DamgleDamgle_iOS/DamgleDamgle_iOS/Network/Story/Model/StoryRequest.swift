//
//  StoryRequest.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Foundation

struct PostStoryRequest {
    let lat: Double
    let lng: Double
    let content: String
}

struct GetStoryFeedRequest {
    let top: Double
    let bottom: Double
    let left: Double
    let right: Double
    let size: Int = 300
    let startFromStoryId: String? = nil
}
