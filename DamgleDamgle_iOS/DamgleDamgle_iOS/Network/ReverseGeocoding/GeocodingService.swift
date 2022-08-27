//
//  GeocodingService.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/31.
//

import Alamofire
import Foundation

struct GeocodingService {
    static func reverseGeocoding(request: GeocodingRequest, completion: @escaping (Result<[String], Error>) -> Void) {
        AF.request(GeocodingTarget.getAddress(request))
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let geocodingResponse = try JSONDecoder().decode(GeocodingResponse.self, from: data)
                        let currentAddress = geocodingResponse.getAddress()
                        completion(.success(currentAddress))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
