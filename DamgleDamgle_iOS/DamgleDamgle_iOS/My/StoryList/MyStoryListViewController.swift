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
    
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var postStroyButton: UIButton! {
        didSet {
            postStroyButton.layer.cornerRadius = 8.0
            postStroyButton.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = createCompositionalLayout()
            collectionView.contentInset = .init(top: 24.0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private let viewModel = MyStoryListViewModel()
    private let cellHeight = 102.0

    private var isRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isRefresh {
            fetchData { }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let count):
                self?.emptyView.alpha = count >= 1 ? 0 : 1.0
                self?.updateBackgroundImageView()
                self?.collectionView.reloadData()
            case .failure(let error):
                // TODO: Error handling
                debugPrint(error.localizedDescription)
            }
            self?.isRefresh = true
            completion()
        }
    }
    
    func showMyStory(at indexPath: IndexPath) {
        let postingMainNavigationViewController = PostingNavigationController.instantiate()
        
        guard let story = viewModel.story(at: indexPath),
              let postingMainViewController = postingMainNavigationViewController.viewControllers.first as? PostingMainViewController
        else {
            return
        }
        
		postingMainViewController.viewModel.setMyStory(with: [story])
        postingMainNavigationViewController.modalPresentationStyle = .overFullScreen
        present(postingMainNavigationViewController, animated: true)
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
    
    private func updateBackgroundImageView() {
        if let numberOfItems = viewModel.dataSource?.snapshot().numberOfItems, numberOfItems > 0, numberOfItems < 4 {
            backgroundBottomConstraint.isActive = false
            backgroundHeightConstraint.isActive = true
            
            if numberOfItems == 1 {
                backgroundHeightConstraint.constant = cellHeight + 70.0
            } else {
                backgroundHeightConstraint.constant = CGFloat(Int(cellHeight + 40.0) * numberOfItems)
            }
        } else {
            backgroundBottomConstraint.isActive = true
            backgroundHeightConstraint.isActive = false
        }
    }
    
    @IBAction private func postStoryButtonDidTap(_ sender: Any) {
        let postViewController = PostViewController()
        postViewController.updateAnimatingView()
        postViewController.viewType = .setting
        present(postViewController, animated: true)
    }
    
    func hiddenScrollViewIndicator(isHidden: Bool) {
        collectionView.showsVerticalScrollIndicator = !isHidden
    }
}

extension MyStoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showMyStory(at: indexPath)
    }
}
