//
//  MyStoryListViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

// TODO: 담글 남기고 my 담글 리스트 reload
final class MyStoryListViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "My", bundle: nil)
    }
    
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var emptyView: UIView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }

    private func fetchData() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let count):
                self?.emptyView.alpha = count >= 1 ? 0 : 1.0
                self?.collectionView.reloadData()
            case .failure(let error):
                // TODO: Error handling
                debugPrint(error.localizedDescription)
            }
            self?.loadingView.isHidden = true
            self?.loadingView.stopAnimating()
        }
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
        // TODO: 인덱스 넘기기
        let postingMainNavigationViewController = PostingNavigationController.instantiate()
        postingMainNavigationViewController.modalPresentationStyle = .fullScreen
        present(postingMainNavigationViewController, animated: true)
    }
}
