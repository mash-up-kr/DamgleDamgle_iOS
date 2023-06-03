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
    
    private let service = StoryService()
    
    private(set) var currentBoundary: NMGLatLngBounds?
    private(set) var postModels: [Story]? {
        didSet {
            storyID = postModels?.first?.id
        }
    }
    private var storyID: String?
    
    func setMapCurrentBoundary(with boundary: NMGLatLngBounds) {
        self.currentBoundary = boundary
    }
    
    func setMyStory(with stories: [Story]) {
        self.postModels = stories
    }
    
    
    func getMyStory(size: Int?, storyID: String?, completion: @escaping (Bool) -> Void) {
        service.getMyStory(size: size, storyID: storyID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let currentStory = response?.stories.first(where: { $0.id == self.storyID })
                
                guard let currentStory = currentStory else {
                    completion(false)
                    return
                }
                
                self.postModels = [currentStory]
                
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func postReaction(storyID: String, type: String, completion: @escaping (Bool) -> Void) {
        StoryService.postReaction(storyID: storyID, type: type) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func deleteReaction(storyID: String, completion: @escaping (Bool) -> Void) {
        StoryService.deleteReaction(storyID: storyID) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func postReport(storyID: String, completion: @escaping (Bool) -> Void) {
        StoryService.postReport(storyID: storyID) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
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
                let stories = self.removeReportStory(response: storyFeed.stories)
                self.postModels = stories
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func getStoryDetail(id: String, completion: @escaping (Result<Story, Error>) -> Void) {
        service.getStoryDetail(storyID: id) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sortStory(with sortType: SortType) {
        switch sortType {
        case .time:
            postModels?.sort(by: { $0.createdAt > $1.createdAt })
        case .popularity:
            postModels?.sort(by: { $0.reactionAllCount > $1.reactionAllCount })
        }
    }
    
//    func sortTime() {
//        postModels?.sort(by: { $0.createdAt > $1.createdAt })
//    }
//
//    func sortPopularity() {
//        postModels?.sort(by: { $0.reactionAllCount > $1.reactionAllCount })
//    }
    
    func changeMyStory(with story: Story) {
        if let index = postModels?.firstIndex(where: { $0.id == story.id })  {
            postModels?[safe: index] = story
        }
    }
    
    private func removeReportStory(response: [Story]?) -> [Story] {
        guard let response = response else { return [] }
        let newStories = removeReportStory(from: response)
        return newStories
    }
    
    private func removeReportStory(from response: [Story]) -> [Story] {
        var stories: [Story] = []
        response.forEach { story in
            if !story.reports.isEmpty {
                var isExitReport = false
                story.reports.forEach { report in
                    if report.userNo == UserManager.shared.userNo {
                        isExitReport = true
                    }
                }
                
                if !isExitReport {
                    stories.append(story)
                }
            } else {
                stories.append(story)
            }
        }
        return stories
    }
}
