//
//  UIColor+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

extension UIColor {
    func toImage(size: CGSize = .init(width: 1, height: 1)) -> UIImage? {
        var image: UIImage?

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return image
    }
}
