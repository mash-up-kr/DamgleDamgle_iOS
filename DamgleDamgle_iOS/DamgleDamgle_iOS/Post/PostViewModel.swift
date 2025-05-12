//
//  PostViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/19.
//

import Foundation
import CoreLocation

/*
 locationService가 MainActor이면 에러 발생
 
 방법 1. PostViewModel을 MainActor로 <- 제일 간단. 근데 이건 포스트를 하는건데.. MainActor를 하는게 맞나? 의문
 방법 2. locationService 값을 필요할때 가져옴 <- 오히려 들고 있지 않아서 안전하지 않을까?(메인 액터 격리된 값을 한 번에 safe하게 "복사해서 들고 나오는 것)
 */
@MainActor
final class PostViewModel {
    private let locationService = LocationService.shared
    
    var postContent: String = ""
    
    func postStory(completion: @escaping (Bool) -> Void) {
        let postStoryRequest = PostStoryRequest(
            lat: locationService.currentLocation.latitude,
            lng: locationService.currentLocation.longitude,
            address1: locationService.currentAddress[safe: 0] ?? "담글이네",
            address2: locationService.currentAddress[safe: 1] ?? "찾는 중",
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

/*
 방법 2 진행 중 포기
 final class PostViewModel {
   var postContent: String = ""
   
   func postStory(completion: @escaping (Bool) -> Void) {
     let content = self.postContent
     
     Task {
       // 1) 한 번에 메인 액터에서 필요한 값을 복사해 온다
       let (location, address): (CLLocationCoordinate2D, [String]) = await MainActor.run {
         let service = LocationService.shared
         return (service.currentLocation, service.currentAddress)
       }
       
       // 현재 컨텍스트에서 필요한 값들을 미리 복사
       
       // 2) 이 이후에는 메인 액터 격리 없이도 loc, addr를 안전하게 사용
       let postStoryRequest = PostStoryRequest(
         lat: location.latitude,
         lng: location.longitude,
         address1: address[safe: 0] ?? "담글이네",
         address2: address[safe: 1] ?? "찾는 중",
         content: content
       )
       
       // 비동기 콜백을 async/await로 변환
       // 클로드가 해준 해결책인데 잘 모르겠네.. 공부 좀 해야할듯?
       let success = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
         StoryService.postStory(request: postStoryRequest) { result in
           switch result {
           case .success(_):
             continuation.resume(returning: true)
           case .failure(_):
             continuation.resume(returning: false)
           }
         }
       }
       
       // 메인스레드에서 안전하게 completion 호출
       await MainActor.run {
         completion(success)
       }
     }
   }
 }
 */
