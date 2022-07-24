//
//  PostingMainViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/02.
//

import UIKit

final class PostingMainViewController: UIViewController {

    var viewModel: PostingViewModel = PostingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.viewModel.delegate = self
    }

    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var timeSortButton: SelectableButton!
    @IBOutlet private weak var popularitySortButton: SelectableButton!
    @IBOutlet private weak var postingTableView: UITableView!

    @IBAction private func timeSortingButtonTouchUp(_ sender: UIButton) {
        self.timeSortButton.isSelected = true
        self.popularitySortButton.isSelected = false
    }

    @IBAction private func popularitySortButtonTouchUp(_ sender: UIButton) {
        self.timeSortButton.isSelected = false
        self.popularitySortButton.isSelected = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = viewModel.postModels[indexPath.row]
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
