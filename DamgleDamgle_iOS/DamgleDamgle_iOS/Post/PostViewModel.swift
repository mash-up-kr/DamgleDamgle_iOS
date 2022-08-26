//
//  PostViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/19.
//

import Foundation

final class PostViewModel {
    private let locationService = LocationService.shared
    
    var postContent: String = ""
    
    func postStory(completion: @escaping (Bool) -> Void) {
        let postStoryRequest = PostStoryRequest(
            lat: locationService.currentLocation.latitude,
            lng: locationService.currentLocation.longitude,
            address1: locationService.currentAddress[safe: 0] ?? "담글이네",
            address2: locationService.currentAddress[safe: 1] ?? "역삼래미안",
            content: postContent
        )
        
        StoryService.postStory(request: postStoryRequest) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
