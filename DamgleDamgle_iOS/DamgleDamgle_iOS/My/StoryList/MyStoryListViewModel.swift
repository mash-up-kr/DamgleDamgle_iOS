//
//  MyStoryListViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import UIKit

final class MyStoryListViewModel {
    // FIXME: test data
    private var stories: [Story] = [
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
        Story(
            id: UUID().uuidString,
            userNo: 10,
            nickname: "TEST",
            x: 1,
            y: 1,
            content: "test",
            reactions: [Reaction(userNo: 10, nickname: "nickName", type: "type")],
            createdAt: 1234,
            updatedAt: 1234
        ),
    ] {
        didSet {
            // TODO: 데이터 없을때 emptyView 보여주기
        }
    }
    
    let service = StoryService()
    var dataSource: UICollectionViewDiffableDataSource<Section, Story>?
    
    var storyCount: Int {
        stories.count
    }
    
    func fetchData() {
        Task {
            // TODO: service.fetchData
            
            await MainActor.run {
                applySnapshot()
            }
        }
    }
    
    func story(at indexPath: IndexPath) -> Story? {
        stories[safe: indexPath.row]
    }
    
    @MainActor
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Story>()
        
        snapshot.appendSections([.myStory])
        snapshot.appendItems(stories, toSection: .myStory)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MyStoryListViewModel {
    enum Section {
        case myStory
    }
}
