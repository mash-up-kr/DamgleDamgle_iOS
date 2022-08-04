//
//  NicknameService.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Alamofire
import Foundation

struct NicknameService {
    static func getNickname(request: GetNicknameRequest, completion: @escaping (Result<NicknameResponse, Error>) -> Void) {
        AF.request(NicknameTarget.getNickname(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(NicknameResponse.self, from: data)
                        completion(.success(model))
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func postNickname(request: PostNicknameRequest, completion: @escaping (Result<NicknameResponse, Error>) -> Void ) {
        AF.request(NicknameTarget.postNickname(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(NicknameResponse.self, from: data)
                        completion(.success(model))
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}



