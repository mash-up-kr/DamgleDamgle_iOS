//
//  StoryboardBased.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

protocol StoryboardBased: AnyObject {
    static var storyboard: UIStoryboard { get }
    static func instantiate() -> Self
}

extension StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            fatalError("Could not find a \(self)")
        }
        return viewController
    }
}
