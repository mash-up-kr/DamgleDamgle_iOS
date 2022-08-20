//
//  MyStoryListViewModel.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import UIKit

final class MyStoryListViewModel {
    private var stories: [Story] = []
    
    let service = StoryService()
    var dataSource: UICollectionViewDiffableDataSource<Section, Story>?
    
    var storyCount: Int {
        stories.count
    }
    
    func fetchData(completion: @escaping (Result<Int, Error>) -> Void) {
        service.getMyStory { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let stories):
                self.stories = stories?.stories ?? []
                self.applySnapshot()
                completion(.success(self.storyCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func story(at indexPath: IndexPath) -> Story? {
        stories[safe: indexPath.row]
    }
    
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
