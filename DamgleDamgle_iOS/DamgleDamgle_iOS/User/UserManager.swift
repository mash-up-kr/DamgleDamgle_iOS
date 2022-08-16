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
    private(set) var accessToken: String
    
    @UserDefault(key: .refreshToken, defaultValue: "")
    private(set) var refreshToken: String
    
    @UserDefault(key: .userNo, defaultValue: 0)
    private(set) var userNo: Int
    
    @UserDefault(key: .refreshToken, defaultValue: "")
    private var refreshToken: String
    
    @UserDefault(key: .userNo, defaultValue: 0)
    private var userNo: Int
    
    var isLogin: Bool {
        accessToken.isEmpty == false
    }
    
    var currentAccessToken: String {
        accessToken
    }
    
    var currentRefreshToken: String {
        refreshToken
    }
    
    var currentUserNo: Int {
        userNo
    }
    
    func updateAccessToken(_ accessToken: String?) {
        guard let accessToken = accessToken else {
            self.accessToken = ""
            return
        }

        self.accessToken = accessToken
    }
    
    func saveRefreshToken(_ refreshToken: String?) {
        guard let refreshToken = refreshToken else {
            return
        }
        
        self.refreshToken = refreshToken
    }
    
    func saveUserNo(_ userNo: Int?) {
        guard let userNo = userNo else {
            self.userNo = 0
            return
        }

        self.userNo = userNo
    }

    func updateRefreshToken(_ refreshToken: String?) {
        guard let refreshToken = refreshToken else {
            self.refreshToken = ""
            return
        }
        
        self.userNo = userNo
    }
    
    func removeAccessToken() {
        accessToken = ""
    }
    
    func updateUserNo(_ userNo: Int?) {
        guard let userNo = userNo else {
            self.userNo = 0
            return
        }

        self.userNo = userNo
    }

    func updateRefreshToken(_ refreshToken: String?) {
        guard let refreshToken = refreshToken else {
            self.refreshToken = ""
            return
        }

        self.refreshToken = refreshToken
    }
}
