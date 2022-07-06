//
//  UIFont+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import UIKit

enum FontWeight {
    case medium
    case semiBold
    case bold
}

enum DamgleFont {
    case title1Bold32
    case bodyBold18
    case bodyBold13
    case bodySemiBold16
    case bodySemiBold11
    case bodySemiBold10
    case bodyMedium24
    case bodyMedium18
    case bodyMedium16
    case bodyMedium13
}

extension DamgleFont {
    var font: UIFont {
        switch self {
        case .title1Bold32:
            return .makeDamgleFont(.bold, 32)
        case .bodyBold18:
            return .makeDamgleFont(.bold, 18)
        case .bodyBold13:
            return .makeDamgleFont(.bold, 13)
        case .bodySemiBold16:
            return .makeDamgleFont(.semiBold, 16)
        case .bodySemiBold11:
            return .makeDamgleFont(.semiBold, 11)
        case .bodySemiBold10:
            return .makeDamgleFont(.semiBold, 10)
        case .bodyMedium24:
            return .makeDamgleFont(.medium, 24)
        case .bodyMedium18:
            return .makeDamgleFont(.medium, 18)
        case .bodyMedium16:
            return .makeDamgleFont(.medium, 16)
        case .bodyMedium13:
            return .makeDamgleFont(.medium, 13)
        }
    }
}

extension UIFont {
    static func makeDamgleFont(_ weight: FontWeight, _ size: CGFloat) -> UIFont {
        switch weight {
        case .medium:
            return UIFont(name: "Pretendard-Medium", size: size)!
        case .semiBold:
            return UIFont(name: "Pretendard-SemiBold", size: size)!
        case .bold:
            return UIFont(name: "Pretendard-Bold", size: size)!
        }
    }
}

