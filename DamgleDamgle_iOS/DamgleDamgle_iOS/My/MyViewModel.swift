//
//  MyViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/20.
//

import Foundation
import Alamofire

final class MyViewModel {
    func getMy(completion: @escaping (Result<Me?, Error>) -> Void) {
        AF.request(MyTarget.getMy)
            .response { response in
                switch response.result {
                case .success(let value):
                    guard let value = value else {
                        return
                    }
                
                    do {
                        let me = try JSONDecoder().decode(Me.self, from: value)
                        completion(.success(me))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
