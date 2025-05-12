//
//  StoryboardBased.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

/*
 StoryboardBased 자체를 MainActor로 할 수도 있을텐데, 그럼 채택하는 곳이 모두 메인쓰레드가 되는거라 따로 preconcurrency하려고 했는데
 어짜피 이거 채택하는 곳들이 전부 UIViewController일거고
 사용하는 곳에서도 storyboard: UIStoryboard 이거 때문에 어짜피 preconcurrency 붙여야 해서 그냥 여기다 메인 액터 붙임
 */
@MainActor
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
