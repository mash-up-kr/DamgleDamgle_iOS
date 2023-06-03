//
//  HomeModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/20.
//

import Foundation
import CoreLocation
import NMapsMap

enum MainIcon: String {
    case sad
    case angry
    case amazing
    case like
    case best
    case none
}

struct HomeModel {
    let markerList: [Marker]
}

struct Marker {
    let mainIcon: MainIcon
    let storyCount: Int
    let markerPosition: CLLocationCoordinate2D
    let storyIdxList: [String]
    let boundary: NMGLatLngBounds
    let isMine: Bool
}
