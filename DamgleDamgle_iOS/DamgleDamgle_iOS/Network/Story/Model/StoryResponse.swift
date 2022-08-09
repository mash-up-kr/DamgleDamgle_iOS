//
//  StoryResponse.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Foundation

struct MyStoryResponse: Decodable {
    let stories: [Story]
    let size: Int
}


