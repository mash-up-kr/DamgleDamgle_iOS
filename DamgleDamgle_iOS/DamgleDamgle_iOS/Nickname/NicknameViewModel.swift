//
//  NicknameViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Alamofire
import Foundation

final class NicknameViewModel {
    
    private(set) var model: NicknameResponse?
    
    func getNickname(completion: @escaping (Bool) -> Void) -> Void {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: nil, noun: nil)) { result in
            switch result {
            case .success(let response):
                self.model = response
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
    func changeAdjective(completion: @escaping (Bool) -> Void) -> Void {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: nil, noun: model?.noun)) { result in
            switch result {
            case .success(let response):
                self.model = response
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
    func changeNoun(completion: @escaping (Bool) -> Void) -> Void {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: model?.adjective, noun: nil)) { result in
            switch result {
            case .success(let response):
                self.model = response
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
    func postNickname(isNotificationEnabled: Bool, completion: @escaping (Bool) -> Void) -> Void {
        guard let model = model else { return }
        NicknameService.postNickname(request: PostNicknameRequest(adjective: model.adjective, noun: model.noun)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.signUp(responce: success, isNotificationEnabled: isNotificationEnabled) { isSuccess in
                    completion(isSuccess)
                }
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
    private func signUp(responce: NicknameResponse, isNotificationEnabled: Bool, completion: @escaping (Bool) -> Void) {
        AuthService.postSignUp(request: PostSignUpRequest(nickname: responce.name, isNotificationEnabled: isNotificationEnabled)) { result in
            switch result {
            case .success(let response):
                UserManager.shared.updateAccessToken(response.accessToken)
                UserManager.shared.saveRefreshToken(response.refreshToken)
                UserManager.shared.saveUserNo(response.userNo)
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
}
