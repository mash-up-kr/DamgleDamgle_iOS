//
//  String+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/21.
//

import Foundation

extension String {
    var textCountWithoutSpacingAndLines: Int {
        let textWithoutSpacing = self.replacingOccurrences(of: " ", with: "")
        let textWithoutSpacingAndLines = textWithoutSpacing.replacingOccurrences(of: "\n", with: "")
        
        return textWithoutSpacingAndLines.count
    }
}
