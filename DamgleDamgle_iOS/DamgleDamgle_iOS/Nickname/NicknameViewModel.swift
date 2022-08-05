//
//  NicknameViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Alamofire
import Foundation

protocol NicknameViewModelDelegate: AnyObject {
    func bind()
}

class NicknameViewModel {
    
    private(set) var model: NicknameResponse? {
        didSet {
            self.delegate?.bind()
        }
    }
    
    weak var delegate: NicknameViewModelDelegate?
    
    init() {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: nil, noun: nil)) { result in
            switch result {
            case .success(let response):
                self.model = response
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func changeAdjective() -> Void {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: nil, noun: model?.noun)) { result in
            switch result {
            case .success(let response):
                self.model = response
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func changeNoun() -> Void {
        NicknameService.getNickname(request: GetNicknameRequest(adjective: model?.adjective, noun: nil)) { result in
            switch result {
            case .success(let response):
                self.model = response
            case .failure(let error):
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
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
}
