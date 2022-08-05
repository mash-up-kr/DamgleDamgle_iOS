//
//  SignUpService.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/31.
//

import Alamofire
import Foundation

struct AuthService {
    static func postSignUp(request: PostSignUpRequest, completion: @escaping (Result<SigningResponse, Error>) -> Void) {
        AF.request(AuthTarget.postSignUp(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let signingResponse = try JSONDecoder().decode(SigningResponse.self, from: data)
                        completion(.success(signingResponse))
                    } catch {
                        completion(.failure(error))
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func postSignIn(request: PostSignInRequest, completion: @escaping (Result<SigningResponse, Error>) -> Void) {
        AF.request(AuthTarget.postSignIn(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let signingResponse = try? JSONDecoder().decode(SigningResponse.self, from: data) else { return }
                    completion(.success(signingResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func getMyInfo(completion: @escaping (Result<GetPatchMyInfoResponse, Error>) -> Void) {
        AF.request(AuthTarget.getMyInfo)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let getMyInfoResponse = try? JSONDecoder().decode(GetPatchMyInfoResponse.self, from: data) else { return }
                    completion(.success(getMyInfoResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func patchNotification(completion: @escaping (Result<GetPatchMyInfoResponse, Error>) -> Void) {
        AF.request(AuthTarget.patchNotification)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let patchMyInfoResponse = try? JSONDecoder().decode(GetPatchMyInfoResponse.self, from: data) else { return }
                    completion(.success(patchMyInfoResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func deleteMyInfo(completion: @escaping (Result<DeleteMyInfoResponse, Error>) -> Void) {
        AF.request(AuthTarget.deleteMyInfo)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let deleteMyInfoResponse = try? JSONDecoder().decode(DeleteMyInfoResponse.self, from: data) else { return }
                    completion(.success(deleteMyInfoResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
