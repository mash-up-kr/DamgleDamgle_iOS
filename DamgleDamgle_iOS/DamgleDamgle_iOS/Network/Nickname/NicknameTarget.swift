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
        case .getNickname(_), .postNickname(_):
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
            let adjective = request.adjective
            let noun = request.noun
            switch (adjective, noun) {
            case (let adjective?, let noun?):
                return [
                    "adjective": adjective,
                    "noun": noun
                ]
            case (let adjective?, nil):
                return [
                    "adjective": adjective
                ]
            case (nil, let noun?):
                return [
                    "noun": noun
                ]
            case (nil, nil):
                return nil
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
