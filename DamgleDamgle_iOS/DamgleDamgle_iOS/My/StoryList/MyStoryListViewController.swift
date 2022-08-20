//
//  MyStoryListViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

final class MyStoryListViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "My", bundle: nil)
    }
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = createCompositionalLayout()
            collectionView.contentInset = .init(top: 24.0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private let viewModel = MyStoryListViewModel()
    private let cellHeight = 102.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        viewModel.fetchData()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(self?.cellHeight ?? 0)
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .zero

            return section
        }
    }
    
    private func configureDataSource() {
        viewModel.dataSource = .init(collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item -> UICollectionViewCell? in
            let story = self?.viewModel.story(at: indexPath)
            let cell = collectionView.dequeueReusableCell(for: indexPath) as MyStoryCollectionViewCell
            cell.configure(story: story)
            return cell
        }
    }
    
    func hiddenScrollViewIndicator(isHidden: Bool) {
        collectionView.showsVerticalScrollIndicator = !isHidden
    }
}

extension MyStoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 눌렀을 때, 담글로 이동
    }
}
