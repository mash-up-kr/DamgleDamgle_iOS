//
//  StoryAPI.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Alamofire
import Foundation

struct StoryAPI {
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
}
