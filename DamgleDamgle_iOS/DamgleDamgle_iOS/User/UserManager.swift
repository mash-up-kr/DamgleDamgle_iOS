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
    
    var isLogin: Bool {
        // TODO: userDefault에 accessToken 저장하고 삭제하는 메서드 만들어서 있는지 여부에 따라 반환
        false
    }
}
