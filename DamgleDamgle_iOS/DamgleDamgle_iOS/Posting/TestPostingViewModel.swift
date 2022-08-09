//
//  TestPostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Alamofire
import Foundation

final class TestPostingViewModel {
    
    private(set) var testPostModels: MyStoryResponse?
    
    init() {
        
        let size: Int? = nil
        let storyID: String? = nil
        StoryService.getMyStory(size: size, storyID: storyID) { result in
            switch result {
            case .success(let response):
                self.testPostModels = response
                print(response)
            case .failure(let error):
                print(error)
            }
        }
        
        //        StoryService.deleteReaction(storyID: storyID) { result in
        //            switch result {
        //            case .success(let response):
        //                print(response)
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
        
        //            let storyID = "62f1115f0b4fe5c97f46e808"
        //            let type = "sad"
        //            StoryService.postReaction(storyID: storyID, type: type) { result in
        //                switch result {
        //                case .success(let response):
        //                    print(response)
        //                case .failure(let error):
        //                    print(error)
        //                }
        //            }
    }
}
