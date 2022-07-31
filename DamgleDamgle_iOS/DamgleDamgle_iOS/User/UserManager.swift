//
//  UserManager.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/30.
//

import Foundation

final class UserManager {
    static let shared: UserManager = UserManager()
    private init() {}

    @UserDefault(key: .accessToken, defaultValue: "")
    private var accessToken: String
    
    var isLogin: Bool {
        accessToken.isEmpty == false
    }
    
    func updateAccessToken(_ accessToken: String?) {
        guard let accessToken = accessToken else {
            self.accessToken = ""
            return
        }

        self.accessToken = accessToken
    }
    
    func removeAccessToken() {
        accessToken = ""
    }
}
