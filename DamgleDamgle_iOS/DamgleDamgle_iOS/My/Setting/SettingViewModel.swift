//
//  SettingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/20.
//

import Alamofire

final class SettingViewModel {
    func patchNotify(completion: @escaping (Error?) -> Void) {
        AF.request(MyTarget.patchNotify)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func deleteMe(completion: @escaping (Error?) -> Void) {
        AF.request(MyTarget.deleteMe)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
}
