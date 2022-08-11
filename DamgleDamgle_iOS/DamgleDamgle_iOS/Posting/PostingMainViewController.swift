//
//  PostingMainViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/02.
//

import UIKit

final class PostingMainViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "PostingStoryboard", bundle: nil)
    }
    
    
    private var apiState: APIState = APIState.dataExit
    var viewModel = TestPostingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        postingTableView.reloadData()
    }
    
    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var timeSortButton: SelectableButton!
    @IBOutlet private weak var popularitySortButton: SelectableButton!
    @IBOutlet private weak var postingTableView: UITableView!
    @IBOutlet private weak var mainViewImageView: UIImageView!
    @IBOutlet private weak var noDataView: UIView!
    
    @IBAction private func timeSortingButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = true
        popularitySortButton.isSelected = false
    }
    
    @IBAction private func popularitySortButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = false
        popularitySortButton.isSelected = true
    }
    
    @IBAction func closeButtonDidTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - TableViewDelegate
extension PostingMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.postModels.count == 0 {
            mainViewImageView.image = APIState.error.BackgroundimageView
        } else if viewModel.postModels.count > 0 {
            mainViewImageView.image = APIState.dataExit.BackgroundimageView
            noDataView.isHidden = true
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
        } else {
            mainViewImageView.image = APIState.dataNone.BackgroundimageView
            noDataView.isHidden = false
        }
    }
}

// MARK: - TableViewDataSource
extension PostingMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiState == APIState.error {
            return 1
        }
        return viewModel.postModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if apiState == APIState.error {
            let cell = tableView.dequeueReusableCell(for: indexPath) as PostErrorTableViewCell
            return cell
        }
        
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

// MARK: - TableViewDelegate
extension PostingMainViewController: TableViewCellDelegate {
    
    func iconButtonAnimationIsClosed(icon: IconsButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.toastButtonAnimate(icon: icon)
            self.postingTableView.reloadData()
        }
    }
    
    private func toastButtonAnimate(icon: IconsButton) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        let toastLabel = ToastLabel()
        toastLabel.setupUI(text: icon.toastMessageTitle)

        toastLabel.frame.origin.x = screenWidth/2 - toastLabel.bounds.width/2
        toastLabel.frame.origin.y = screenHeight - toastLabel.bounds.height - screenHeight*(64/812)
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

enum APIState {
    case dataExit
    case dataNone
    case error
    
    var BackgroundimageView: UIImage? {
        switch self {
        case .dataExit: return UIImage(named: "img_list_bg")
        case .dataNone: return nil
        case .error: return UIImage(named: "img_list_error_bg_posting")
        }
    }
}
