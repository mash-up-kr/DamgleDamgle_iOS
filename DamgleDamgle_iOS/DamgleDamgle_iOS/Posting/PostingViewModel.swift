//
//  TestPostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import Alamofire
import Foundation
import NMapsMap

final class PostingViewModel {
    
    var currentBoundary: NMGLatLngBounds?
    private(set) var postModels: [Story]?
    private let service = StoryService()
    
    func getMyStory(size: Int?, storyID: String?, completion: @escaping (Bool) -> Void) {
        service.getMyStory(size: size, storyID: storyID) { result in
            switch result {
            case .success(let response):
                self.postModels = response?.stories
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
    
    func postReport(storyID: String, completion: @escaping (Bool) -> Void) {
        StoryService.postReport(storyID: storyID) { result in
            switch result {
            case .success(let rsponse):
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func getStoryFeed(completion: @escaping (Bool) -> Void) {
        guard let currentBoundary = currentBoundary else { return }
        
        let storyRequest = GetStoryFeedRequest(top: currentBoundary.northEastLat, bottom: currentBoundary.southWestLat, left: currentBoundary.southWestLng, right: currentBoundary.northEastLng)
        
        service.getStoryFeed(request: storyRequest) { result in
            switch result {
            case .success(let storyFeed):
                self.postModels = storyFeed.stories
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func sortTime() {
        postModels?.sort(by: { $0.createdAt > $1.createdAt })
    }
    
    func sortPopularity() {
        postModels?.sort(by: { $0.reactionAllCount > $1.reactionAllCount })
    }
}
