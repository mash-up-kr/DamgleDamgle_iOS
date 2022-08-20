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
    
    func getMyStory(completion: @escaping (Result<Stories?, Error>) -> Void) {
        AF.request(StoryTarget.getMyStory(size: 300, storyID: nil))
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
}
