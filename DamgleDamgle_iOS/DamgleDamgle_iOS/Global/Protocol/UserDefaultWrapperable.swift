//
//  UserDefaultWrapperable.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/30.
//

import Foundation

protocol UserDefaultWrapperable {
    associatedtype T

    var defaultValue: T { get set }
    var suiteName: String? { get set }
    var userDefaults: UserDefaults? { get }
}

extension UserDefaultWrapperable {
    var userDefaults: UserDefaults? {
        UserDefaults.standard
    }
}

@propertyWrapper
struct UserDefault<T>: UserDefaultWrapperable {
    typealias T = T

    var key: UserDefaults.Key
    var defaultValue: T
    var suiteName: String?

    var wrappedValue: T {
        get {
            userDefaults?.value(forKey: key) ?? defaultValue
        }
        set {
            userDefaults?.setValue(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    enum Key: String {
        case accessToken
        case refreshToken
        case userNo
    }
}

extension UserDefaults {
    func setValue(_ value: Any, forKey key: UserDefaults.Key) {
        setValue(value, forKey: key.rawValue)
    }

    func value<T>(forKey key: UserDefaults.Key) -> T? {
        value(forKey: key.rawValue) as? T
    }
}
