//
//  TestPostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Alamofire
import Foundation

final class PostingViewModel {
    
    private(set) var postModels: Stories?
    private let service = StoryService()
    
    func getMyStory(size: Int?, storyID: String?, completion: @escaping (Bool) -> Void) {
        service.getMyStory(size: size, storyID: storyID) { result in
            switch result {
            case .success(let response):
                self.postModels = response
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func postReaction(storyID: String, type: String, completion: @escaping (Bool) -> Void) {
        StoryService.postReaction(storyID: storyID, type: type) { result in
            switch result {
            case .success(let response):
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func deleteReaction(storyID: String, completion: @escaping (Bool) -> Void) {
        StoryService.deleteReaction(storyID: storyID) { result in
            switch result {
            case .success(let response):
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func sortTime() {
        postModels?.stories.sort(by: { $0.createdAt > $1.createdAt })
    }
    
    func sortPopularity() {
        postModels?.stories.sort(by: { $0.reactionAllCount > $1.reactionAllCount })
    }
}
