//
//  Bundle+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Foundation

extension Bundle {
    var CLIENT_ID: String {
        guard let file = self.path(forResource: "NMapsMapId", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["CLIENT_ID"] as? String else {
            fatalError("CLIENT_ID error")
        }
        return key
    }
    
    var CLIENT_SECRET: String {
        guard let file = self.path(forResource: "NMapsMapId", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["CLIENT_SECRET"] as? String else {
            fatalError("CLIENT_ID error")
        }
        return key
    }
}
