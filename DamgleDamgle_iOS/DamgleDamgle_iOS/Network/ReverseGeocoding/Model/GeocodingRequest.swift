//
//  GeocodingRequest.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Foundation

struct GeocodingRequest {
    let lat: Double
    let lng: Double
    let output: String = "json"
    let orders: String = "roadaddr"
}
