//
//  PostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation

class PostingViewModel {

    var postModels: [PostModel] 

    init() {
        let postModels: [PostModel] = [
            PostModel(id: 0, placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(id: 1, placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(id: 2, placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true),
            PostModel(id: 3, placeAddress: "충무로", time: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", checkMyContent: true)
        ]

        self.postModels = postModels
    }

    internal func addIconInModel(original: PostModel, icon: iconsButton) -> Void {
        let newPostModel = self.postModels.map { (model: PostModel) -> PostModel in
            if model.id == original.id {
                return PostModel(id: original.id, placeAddress: original.placeAddress, time: original.time, content: original.content, userName: original.userName, checkMyContent: original.checkMyContent, icon: icon)
            } else {
                return PostModel(id: original.id, placeAddress: original.placeAddress, time: original.time, content: original.content, userName: original.userName, checkMyContent: original.checkMyContent, icon: nil)
            }
        }
        self.postModels = newPostModel
    }

    internal func deleteIconInModel(original: PostModel) -> Void {
        let newPostModel = self.postModels.map { (model: PostModel) -> PostModel in
            if model.id == original.id {
                return PostModel(id: original.id, placeAddress: original.placeAddress, time: original.time, content: original.content, userName: original.userName, checkMyContent: original.checkMyContent, icon: nil)
            } else {
                return PostModel(id: original.id, placeAddress: original.placeAddress, time: original.time, content: original.content, userName: original.userName, checkMyContent: original.checkMyContent, icon: nil)
            }
        }
        self.postModels = newPostModel
    }
}
