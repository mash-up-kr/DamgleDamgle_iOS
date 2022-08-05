//
//  SignUpTarget.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/31.
//

import Alamofire
import Foundation

enum AuthTarget {
    case postSignUp(_ request: PostSignUpRequest)
    case postSignIn(_ request: PostSignInRequest)
    case getMyInfo
    case patchNotification
    case deleteMyInfo
}

extension AuthTarget: URLRequestConvertible {
    var baseURL: URL {
        URL(string: "https://api-dev.damgle.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .postSignUp(_), .postSignIn(_):
            return .post
        case .getMyInfo:
            return .get
        case .patchNotification:
            return .patch
        case .deleteMyInfo:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postSignUp(_):
            return "/v1/auth/signup"
        case .postSignIn(_):
            return "/v1/auth/signin"
        case .getMyInfo:
            return "/v1/auth/me"
        case .patchNotification:
            return "/v1/auth/notify"
        case .deleteMyInfo:
            return "/v1/auth/deleteme"
        }
    }
    
    var header: HTTPHeaders {
        [
            "Content-Type": "application/json"
            // TODO: key 추가
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case .postSignUp(let request):
            return [
                "nickname": request.nickname,
                "notification": request.isNotificationEnabled
            ]
        case .postSignIn(let request):
            return [
                "userNo": request.userNo,
                "refreshToken": request.refreshToken
            ]
        case .getMyInfo, .patchNotification, .deleteMyInfo:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        
        var encoding: ParameterEncoding
        switch self {
        case .postSignUp(_), .postSignIn(_):
            encoding = JSONEncoding.default
        case .getMyInfo, .patchNotification, .deleteMyInfo:
            encoding = URLEncoding.queryString
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
