//
//  UIView+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/14.
//

import UIKit

extension UIView {
    func addGradientLayer(startColor: UIColor, endColor: UIColor = .clear) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: bounds.size)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.5, 1.0]
        layer.insertSublayer(gradient, at: 0)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: bounds.width, height: bounds.height))
        let renderImage = renderer.image {_ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return renderImage
    }
}
