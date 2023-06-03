//
//  GeocodingTarget.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Alamofire
import Foundation

enum GeocodingTarget {
    case getAddress(_ request: GeocodingRequest)
}

extension GeocodingTarget: URLRequestConvertible {
    var baseURL: URL {
        URL(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAddress(_):
            return .get
        }
    }
    
    var header: HTTPHeaders {
        [
            "X-NCP-APIGW-API-KEY-ID": Bundle.main.CLIENT_ID,
            "X-NCP-APIGW-API-KEY": Bundle.main.CLIENT_SECRET
        ]
    }
    
    var parameters: Parameters {
        switch self {
        case .getAddress(let request):
            return [
                "coords": "\(request.lng),\(request.lat)",
                "output": request.output,
                "orders": request.orders
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        
        let encoding = URLEncoding.queryString
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
