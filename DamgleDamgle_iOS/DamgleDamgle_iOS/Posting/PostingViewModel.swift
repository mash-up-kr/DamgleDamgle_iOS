//
//  PostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation
import RxSwift

class PostingViewModel {

    var postObservable = BehaviorSubject<[PostModel]>(value: [])

    init() {
        let postModel: [PostModel] = [
            PostModel(placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true)
        ]

        self.postObservable.onNext(postModel)
    }
}
