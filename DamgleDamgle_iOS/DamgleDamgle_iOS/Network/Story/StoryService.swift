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
    
    static func getMyStory(size: Int?, storyID: String?, completion: @escaping (Result<MyStoryResponse, Error>) -> Void) {
        AF.request(StoryTarget.getMyStory(size: size, storyID: storyID))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(MyStoryResponse.self, from: data)
                        completion(.success(model))
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
    
    static func postReport(storyID: String, completion: @escaping (Result<Bool, Error>) -> Void ) {
        AF.request(StoryTarget.postReport(storyID: storyID))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
