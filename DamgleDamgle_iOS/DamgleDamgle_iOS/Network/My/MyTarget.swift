//
//  MyTarget.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/20.
//

import Alamofire
import Foundation

enum MyTarget {
    case getMy
    case patchNotify
    case deleteMe
}

extension MyTarget: URLRequestConvertible {
    var baseURL: URL {
        URL(string: "https://api-dev.damgle.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMy:
            return .get
        case .patchNotify:
            return .patch
        case .deleteMe:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getMy:
            return "/v1/auth/me"
        case .patchNotify:
            return "/v1/auth/notify"
        case .deleteMe:
            return "/v1/auth/deleteme"
        }
    }
    
    var header: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.currentAccessToken)"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        
        return try URLEncoding.default.encode(urlRequest, with: nil)
    }
}
