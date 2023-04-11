//
//  PostingNavigationController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import UIKit

final class PostingNavigationController: UINavigationController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "PostingStoryboard", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.modalPresentationStyle = .fullScreen
    }
}
