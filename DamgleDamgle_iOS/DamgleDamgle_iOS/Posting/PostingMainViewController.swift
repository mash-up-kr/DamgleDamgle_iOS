//
//  PostingMainViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class PostingMainViewController: UIViewController {

    private let postingViewModel = PostingViewModel()

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeSortButton.rx.tap
            .bind { [weak self] _ in

                guard let self = self else { return }

                self.timeSortButton.isSelected = true
                self.popularitySortButton.isSelected = false

            }
            .disposed(by: self.disposeBag)

        self.popularitySortButton.rx.tap
            .bind { [weak self] _ in

                guard let self = self else { return }

                self.popularitySortButton.isSelected = true
                self.timeSortButton.isSelected = false

            }
            .disposed(by: self.disposeBag)

        self.postingViewModel.postObservable
            .observe(on: MainScheduler.instance)
            .bind(to: self.postingTableView.rx.items(cellIdentifier: PostTableViewCell.identifier, cellType: PostTableViewCell.self)) { index, item, cell in

                cell.onData.onNext(item)
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var timeSortButton: SelectableButton!
    @IBOutlet private weak var popularitySortButton: SelectableButton!
    @IBOutlet private weak var postingTableView: UITableView!
}
