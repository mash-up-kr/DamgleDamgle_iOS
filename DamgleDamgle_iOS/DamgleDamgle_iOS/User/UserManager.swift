//
//  UserManager.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/30.
//

import Foundation

/*
 Static property 'shared' is not concurrency-safe because non-'Sendable' type 'UserManager' may have shared mutable state
 
 UserManager가 Sendable 하지 않은데 shared로 전역 인스턴스임
 해결 방법 1. UserManager를 MainActor에서 돌리기 <- 가능은 하지만 사실상 UI 이슈가 아니니까 좀 별로인듯
 해결 방법 2. UserManager를 Actor로 변경 <- 이게 맞을 듯
 
 회피 방법 1. final class UserManager: @unchecked Sendable { <- 이 클래스 자체를 체크하지 않기
 회피 방법 2. nonisolated(unsafe) static let shared: UserManager = UserManager() <- shared를 체크하지 않기
 
 일단은 해결 방법 2가 맞지만, 회피 방법 1은 너무 범위가 넓으므로, 회피 방법 2로 수정
 
 하려다가 보니 UserManager가 가지고 있는 값들이 모두 Sendable해서, Sendable을 채택하면 어떨까 했는데
 UserDefault 때문에 복잡해져서 다시 회피 방법 2
 */

final class UserManager {
  nonisolated(unsafe) static let shared: UserManager = UserManager()
    private init() {}

    @UserDefault(key: .accessToken, defaultValue: "")
    private(set) var accessToken: String
    
    @UserDefault(key: .refreshToken, defaultValue: "")
    private(set) var refreshToken: String
    
    @UserDefault(key: .userNo, defaultValue: 0)
    private(set) var userNo: Int
    
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
