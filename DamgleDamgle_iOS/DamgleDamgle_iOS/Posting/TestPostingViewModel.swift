//
//  TestPostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Alamofire
import Foundation

final class TestPostingViewModel {
    
    private(set) var postModels: MyStoryResponse?
    
    func getMyStory(size: Int?, storyID: String?,completion: @escaping (Bool) -> Void) {
        StoryService.getMyStory(size: size, storyID: storyID) { result in
            switch result {
            case .success(let response):
                self.postModels = response
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
    func postReaction(storyID: String, type: String) {
        StoryService.postReaction(storyID: storyID, type: type) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteReaction(storyID: String) {
        StoryService.deleteReaction(storyID: storyID) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
