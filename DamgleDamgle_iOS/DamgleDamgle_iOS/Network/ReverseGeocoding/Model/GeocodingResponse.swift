//
//  GeocodingResponse.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/31.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let systemWeather = try? newJSONDecoder().decode(SystemWeather.self, from: jsonData)

import Foundation

// MARK: - SystemWeather
struct GeocodingResponse: Codable {
    let status: Status
    let results: [ReverseResult]
    
    func getAddress() -> [String] {
        let defaultAddress = ["담글이네", "찾는 중"]
        
        var address: [String] = []
        
        guard let town = self.results.first?.region.area3.name else { return defaultAddress }
        
        if let streetAddress = self.results.first?.land.name {
            if streetAddress != "" {
                address = [town, streetAddress]
            } else {
                guard let district = self.results.first?.region.area2.name else { return defaultAddress }
                address = [district, town]
            }
        }
    
        if address.isEmpty {
            address = defaultAddress
        }
        
        return address
    }
}

// MARK: - Result
struct ReverseResult: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
}

// MARK: - Code
struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

// MARK: - Land
struct Land: Codable {
    let type, number1, number2: String
    let addition0, addition1, addition2, addition3: Addition
    let addition4: Addition
    let name: String
    let coords: Coords
}

// MARK: - Addition
struct Addition: Codable {
    let type, value: String
}

// MARK: - Coords
struct Coords: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let crs: String
    let x, y: Double
}

// MARK: - Region
struct Region: Codable {
    let area0: Area
    let area1: Area1
    let area2, area3, area4: Area
}

// MARK: - Area
struct Area: Codable {
    let name: String
    let coords: Coords
}

// MARK: - Area1
struct Area1: Codable {
    let name: String
    let coords: Coords
    let alias: String
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let name, message: String
}
