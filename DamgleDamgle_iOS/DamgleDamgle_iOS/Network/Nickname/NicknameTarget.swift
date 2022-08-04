//
//  NicknameTarget.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Alamofire
import Foundation

enum NicknameTarget {
    case getNickname(_ request: GetNicknameRequest)
    case postNickname(_ request: PostNicknameRequest)
}

extension NicknameTarget: URLRequestConvertible {
    var baseURL: URL {
        URL(string: "https://api-dev.damgle.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNickname(_):
            return .get
        case .postNickname(_):
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getNickname(_):
            return "/v1/namepicker"
        case .postNickname(_):
            return "/v1/namepicker"
        }
    }
    
    var header: HTTPHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case .getNickname(let request):
            if let adjective = request.adjective {
                if let noun = request.noun {
                    return [
                        "adjective": adjective,
                        "noun": noun
                    ]
                } else {
                    return [
                        "adjective": adjective
                    ]
                }
            } else {
                if let noun = request.noun {
                    return [
                        "noun": noun
                    ]
                } else {
                    return nil
                }
            }
        case .postNickname(let request):
            return [
                "adjective": request.adjective,
                "noun": request.noun
            ]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        
        var encoding: ParameterEncoding
        switch self {
        case .getNickname(_):
            encoding = URLEncoding.queryString
        case .postNickname(_):
            encoding = JSONEncoding.default
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
