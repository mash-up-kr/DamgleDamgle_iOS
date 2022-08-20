//
//  StoryService.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Alamofire
import Foundation

struct StoryService {
    static func postStory(request: PostStoryRequest, completion: @escaping (Result<Bool, Error>) -> Void ) {
        AF.request(StoryTarget.postStory(request))
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getMyStory(size: Int? = 300, storyID: String? = nil, completion: @escaping (Result<Stories?, Error>) -> Void) {
        AF.request(StoryTarget.getMyStory(size: size, storyID: storyID))
            .response { response in
                switch response.result {
                case .success(let value):
                    guard let value = value else {
                        return
                    }
                    
                    do {
                        let stories = try JSONDecoder().decode(Stories.self, from: value)
                        completion(.success(stories))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func postReaction(storyID: String, type: String, completion: @escaping (Result<Story, Error>) -> Void ) {
        AF.request(StoryTarget.postReaction(storyID: storyID, type: type))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Story.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func deleteReaction(storyID: String, completion: @escaping (Result<Story, Error>) -> Void ) {
        AF.request(StoryTarget.deleteReaction(storyID: storyID))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Story.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func getStoryFeed(request: GetStoryFeedRequest, completion: @escaping (Result<StoryFeed, Error>) -> Void) {
        AF.request(StoryTarget.getStoryFeed(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let storyFeedResponse = try JSONDecoder().decode(StoryFeed.self, from: data)
                        completion(.success(storyFeedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func postReport(storyID: String, completion: @escaping (Result<Bool, Error>) -> Void ) {
        AF.request(StoryTarget.postReport(storyID: storyID))
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
