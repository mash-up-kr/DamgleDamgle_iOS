//
//  PostingViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation

final class TestPostingViewModel {
    
    private(set) var postModels: [PostModel]

    init() {
        let postModels: [PostModel] = [
            PostModel(id: 0, placeAddress: "충무로", timeText: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", isChecked: false, selectedIcons: [SelectedIconButton(icon: IconsButton.likeButton, count: 5),SelectedIconButton(icon: IconsButton.bestButton, count: 3),SelectedIconButton(icon: IconsButton.sadButton, count: 2),SelectedIconButton(icon: IconsButton.amazingButton, count: 1)]),
            PostModel(id: 1, placeAddress: "충무로", timeText: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", isChecked: false, selectedIcons: [SelectedIconButton(icon: IconsButton.bestButton, count: 5)]),
            PostModel(id: 2, placeAddress: "충무로", timeText: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", isChecked: false, selectedIcons: []),
            PostModel(id: 3, placeAddress: "충무로", timeText: "10:10", content: "안녕하세요. 충무로 투섬플레이스 입니다. 잘 부탁드립니다.", userName: "시원한 대머리독수리 1호", isChecked: false, selectedIcons: [SelectedIconButton(icon: IconsButton.likeButton, count: 5),SelectedIconButton(icon: IconsButton.angryButton, count: 4),SelectedIconButton(icon: IconsButton.bestButton, count: 3),SelectedIconButton(icon: IconsButton.sadButton, count: 2),SelectedIconButton(icon: IconsButton.amazingButton, count: 1)])
        ]

        self.postModels = postModels
    }

    func addIconInModel(original: PostModel, icon: IconsButton) -> Void {
        let newPostModel = self.postModels.map { (model: PostModel) -> PostModel in
            if model.id == original.id {
                var newSelectedIcons = makePlusIconsModel(selectedIcons: original.selectedIcons, icon: icon)
                if let icon = original.icon {
                    newSelectedIcons = makeMinusIconsModel(selectedIcons: newSelectedIcons, icon: icon)
                }
                return PostModel(id: original.id,
                                 placeAddress: original.placeAddress,
                                 timeText: original.timeText,
                                 content: original.content,
                                 userName: original.userName,
                                 isChecked: original.isChecked,
                                 icon: icon,
                                 selectedIcons: newSelectedIcons)
            } else {
                return model
            }
        }
        self.postModels = newPostModel
    }

    func deleteIconInModel(original: PostModel, icon: IconsButton) -> Void {
        let newPostModel = self.postModels.map { (model: PostModel) -> PostModel in
            if model.id == original.id {
                var newSelectedIcons = makeMinusIconsModel(selectedIcons: original.selectedIcons, icon: icon)
                return PostModel(id: original.id,
                                 placeAddress: original.placeAddress,
                                 timeText: original.timeText,
                                 content: original.content,
                                 userName: original.userName,
                                 isChecked: original.isChecked,
                                 icon: nil,
                                 selectedIcons: newSelectedIcons)
            } else {
                return model
            }
        }
        self.postModels = newPostModel
    }

    private func makePlusIconsModel(selectedIcons: [SelectedIconButton], icon: IconsButton) -> [SelectedIconButton] {
        var newSelectedIcons: [SelectedIconButton] = selectedIcons
        let newIconsButton: [IconsButton] = selectedIcons.map { (selectedIcon: SelectedIconButton) -> IconsButton in
            let iconButton = selectedIcon.icon
            return iconButton
        }
        if !newIconsButton.contains(icon) {
            newSelectedIcons.append(SelectedIconButton(icon: icon, count: 1))
        } else {
            let plusSelectedIcons: [SelectedIconButton] = selectedIcons.map { (selectedIcon: SelectedIconButton) -> SelectedIconButton in
                var selectedIcon = selectedIcon
                if selectedIcon.icon == icon {
                    selectedIcon.plusCount()
                }
                return selectedIcon
            }
            newSelectedIcons = plusSelectedIcons
        }
        return newSelectedIcons
    }

    private func makeMinusIconsModel(selectedIcons: [SelectedIconButton], icon: IconsButton) -> [SelectedIconButton] {
        var newSelectedIcons: [SelectedIconButton] = selectedIcons.map { (selectedIcon: SelectedIconButton) -> SelectedIconButton in
            var selectedIcon = selectedIcon
            if selectedIcon.icon == icon {
                selectedIcon.minusCount()
            }
            return selectedIcon
        }

        let temp = newSelectedIcons
        for (index, icon) in temp.enumerated() {
            if (icon.count == 0) {
                newSelectedIcons.remove(at: index)
            }
        }
        return newSelectedIcons
    }
}
