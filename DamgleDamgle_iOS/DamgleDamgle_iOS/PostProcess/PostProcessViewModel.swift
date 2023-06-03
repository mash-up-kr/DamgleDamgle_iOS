//
//  PostProcessViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/27.
//

import Foundation

final class PostProcessViewModel {
    
    let service = StoryService()
    
    func fetchData(completion: @escaping (Story?) -> Void) {
        service.getMyStory { result in
            switch result {
            case .success(let stories):
                completion(stories?.stories.first)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
