//
//  PostingMainViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/02.
//

import UIKit

final class PostingMainViewController: UIViewController {

    var viewModel = PostingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var timeSortButton: SelectableButton!
    @IBOutlet private weak var popularitySortButton: SelectableButton!
    @IBOutlet private weak var postingTableView: UITableView!
    @IBOutlet private weak var mainViewBackgroundImageView: UIImageView!

    @IBAction private func timeSortingButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = true
        popularitySortButton.isSelected = false
    }

    @IBAction private func popularitySortButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = false
        popularitySortButton.isSelected = true
    }
}

// MARK: - TableViewDelegate
extension PostingMainViewController: UITableViewDelegate {
}

// MARK: - TableViewDataSource
extension PostingMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
        let viewModel = self.viewModel.postModels[indexPath.row]
        cell.setupUI(viewModel: viewModel)
        cell.addSelectedIcon = { [weak self] iconButton in
            guard let self = self else { return }
            self.viewModel.addIconInModel(original: viewModel, icon: iconButton)
        }
        cell.deleteSeletedIcon = { [weak self] iconsButton in
            guard let self = self else { return }
            self.viewModel.deleteIconInModel(original: viewModel, icon: iconsButton)
        }
        cell.delegate = self

        return cell
    }
}

extension PostingMainViewController: TableViewCellDelegate {
    func iconButtonAnimationIsClosed() {
        self.postingTableView.reloadData()
    }
}
