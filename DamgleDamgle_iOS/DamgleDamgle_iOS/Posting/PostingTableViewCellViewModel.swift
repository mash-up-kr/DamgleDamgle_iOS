//
//  PostingTableViewCellViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/30.
//

import Foundation
import Alamofire

final class PostingTableViewCellViewModel  {
    
    private let service = StoryService()
    
    private(set) var storyModel: Story?
    
    func getStoryDetail(id: String, completion: @escaping (Result<Story, Error>) -> Void) {
        service.getStoryDetail(storyID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.storyModel = response
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postReaction(storyID: String, type: String, completion: @escaping (Result<Story, Error>) -> Void) {
        StoryService.postReaction(storyID: storyID, type: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.service.getStoryDetail(storyID: storyID) { result in
                    switch result {
                    case .success(let response):
                        self.storyModel = response
                        completion(.success(response))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteReaction(storyID: String, completion: @escaping (Result<Story, Error>) -> Void) {
        StoryService.deleteReaction(storyID: storyID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.service.getStoryDetail(storyID: storyID) { result in
                    switch result {
                    case .success(let response):
                        self.storyModel = response
                        completion(.success(response))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateStoryModel(Story: Story?) {
        self.storyModel = Story
    }
}
