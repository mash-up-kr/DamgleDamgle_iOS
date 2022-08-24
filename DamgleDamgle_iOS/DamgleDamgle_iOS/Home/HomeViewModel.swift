//
//  HomeViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/20.
//

import Foundation
import NMapsMap

final class HomeViewModel {
    
    private let latDivision = 4
    private let lngDivision = 3
    
    private let storyService = StoryService()
    
    var currentBoundary: NMGLatLngBounds?
    
    var currentModel = HomeModel(markerList: [])
    
    private func findMaxReaction(stories: [Story]) -> MainIcon {
        var reactionCountDict: [MainIcon: Int] = [:]
        
        stories.forEach { story in
            story.reactions.forEach { reaction in
                let currentReaction = MainIcon(rawValue: reaction.type) ?? .amazing
                if let currentReactionCount = reactionCountDict[currentReaction] {
                    reactionCountDict[currentReaction] = currentReactionCount + 1
                } else {
                    reactionCountDict[currentReaction] = 1
                }
            }
        }
        
        let sortedReactionCountDict = reactionCountDict.sorted { $0.1 > $1.1 }
        
        return sortedReactionCountDict.first?.key ?? .none
    }
    
    private func convertStoryFeedToMarker(storyList: [Story], boundary: NMGLatLngBounds) -> Marker {
        let mainIcon = findMaxReaction(stories: storyList)
        
        if storyList.count > 0 {
            let firstStory = storyList.first!
            let firstStoryPosition = CLLocationCoordinate2D(latitude: CLLocationDegrees(firstStory.y), longitude: CLLocationDegrees(firstStory.x))
            
            let storyIdxList = storyList.map { $0.id }
            let haveMyStory = storyList.filter { $0.isMine == true }.count > 0
            
            return Marker(
                mainIcon: mainIcon,
                storyCount: storyList.count,
                markerPosition: firstStoryPosition,
                storyIdxList: storyIdxList,
                boundary: boundary,
                isMine: haveMyStory
            )
        } else {
            return Marker(mainIcon: .none, storyCount: 0, markerPosition: CLLocationCoordinate2D(), storyIdxList: [], boundary: NMGLatLngBounds(), isMine: true)
        }
    }
    
    func getStoryFeed(completion: @escaping (Result<HomeModel?, Error>) -> Void) {
        guard let currentBoundary = currentBoundary else { return }
        
        let storyRequest = GetStoryFeedRequest(top: currentBoundary.northEastLat, bottom: currentBoundary.southWestLat, left: currentBoundary.southWestLng, right: currentBoundary.northEastLng)
        
        storyService.getStoryFeed(request: storyRequest) { result in
            switch result {
            case .success(let storyFeed):
                if storyFeed.size > 0 {
                    self.getStoryFeedForRegion(stories: storyFeed.stories) { homeModel in
                        completion(.success(homeModel))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getStoryFeedForRegion(stories: [Story], completion: @escaping (HomeModel) -> Void) {
        guard let currentBoundary = currentBoundary else { return }
        
        let topLat = currentBoundary.northEastLat
        let bottomLat = currentBoundary.southWestLat

        let rightLng = currentBoundary.northEastLng
        let leftLng = currentBoundary.southWestLng
        
        let diffLat = (topLat - bottomLat) / Double(latDivision)
        let diffLng = (rightLng - leftLng) / Double(lngDivision)
        
        var markerList: [Marker] = []
        
        for i in 1...latDivision {
            for j in 1...lngDivision {
                var currentBoundaryStoryList: [Story] = []

                let startLat = topLat - diffLat * Double(i - 1)
                let startLng = leftLng + diffLng * Double(j - 1)
                let endLat = topLat - diffLat * Double(i)
                let endLng = leftLng + diffLng * Double(j)
                
                stories.forEach { story in
                    if (startLng..<endLng).contains(story.x) && (endLat..<startLat).contains(story.y) {
                        currentBoundaryStoryList.append(story)
                    }
                }

                if currentBoundaryStoryList.count > 0 {
                    let currentBoundary = NMGLatLngBounds(southWestLat: endLat, southWestLng: startLng, northEastLat: startLat, northEastLng: endLng)
                    let marker = convertStoryFeedToMarker(storyList: currentBoundaryStoryList, boundary: currentBoundary)
                    markerList.append(marker)
                }
            }
        }
        
        currentModel = HomeModel(markerList: markerList)
        completion(currentModel)
    }
}
