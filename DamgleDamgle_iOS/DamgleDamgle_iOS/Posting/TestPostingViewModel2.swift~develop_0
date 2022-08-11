//
//  TestPostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Alamofire
import Foundation

final class TestPostingViewModel2 {
    
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
    
    func sortTime() {
        postModels?.stories.sort(by: { $0.createdAt > $1.createdAt })
    }
    
    func sortPopularity() {
        // TODO: 서버로부터 좋아요 숫자 Response를 받은 후 로직을 만들 예정
        postModels?.stories.sort(by: { $0.id > $1.id })
    }
}
