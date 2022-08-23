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
    
    @IBOutlet private weak var timeSortButton: SelectableButton!
    @IBOutlet private weak var popularitySortButton: SelectableButton!
    @IBOutlet private weak var postingTableView: UITableView!
    @IBOutlet private weak var mainViewImageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private var apiState: APIState = .dataExit
    var type: StoryType = .myStory
    var viewModel = PostingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == .myStory {
            getMyStoryResponse()
        } else {
            getFeedStoryResponse()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        postingTableView.reloadData()
    }
    
    private func getMyStoryResponse() {
        activityIndicatorView.startAnimating()
        viewModel.getMyStory(size: 300, storyID: nil) { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.apiState = isSuccess ? .dataExit : .error
                self.postingTableView.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func getFeedStoryResponse() {
        activityIndicatorView.startAnimating()
        viewModel.getStoryFeed() { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.apiState = isSuccess ? .dataExit : .error
                self.postingTableView.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction private func timeSortingButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = true
        popularitySortButton.isSelected = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
            self.viewModel.sortTime()
            self.postingTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    @IBAction private func popularitySortButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = false
        popularitySortButton.isSelected = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
            self.viewModel.sortPopularity()
            self.postingTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    @IBAction private func closeButtonDidTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - TableViewDelegate
extension PostingMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if apiState == APIState.error {
            mainViewImageView.image = APIState.error.BackgroundimageView
            getMyStoryResponse()
        } else {
            mainViewImageView.image = APIState.dataExit.BackgroundimageView
        }
    }
}

// MARK: - TableViewDataSource
extension PostingMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiState == APIState.error {
            return 1
        }
        return viewModel.postModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if apiState == APIState.error {
            let cell = tableView.dequeueReusableCell(for: indexPath) as PostErrorTableViewCell
            cell.setupUI()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
        let viewModel = self.viewModel.postModels?[indexPath.row]
        cell.setupUI(viewModel: viewModel)
        
        cell.addSelectedIcon = { [weak self] reaction in
            guard let self = self, let id = viewModel?.id else { return }
            self.viewModel.postReaction(storyID: id, type: reaction.rawValue) { isSuccess in
                // TODO: 실패했을때 대응방법 적용예정
            }
        }
        cell.deleteSeletedIcon = { [weak self] in
            guard let self = self, let id = viewModel?.id else { return }
            self.viewModel.deleteReaction(storyID: id) { isSuccess in
                // TODO: 실패했을때 대응방법 적용예정
            }
        }
        
        cell.postReport = { [weak self] in
            guard let self = self, let id = viewModel?.id else { return }
            // TODO: Report Logic 구현예정
//            self.viewModel.postReport(storyID: id) { isSuccess in
//
//            }
            self.showAlertController(
                type: .single,
                title: "신고하기 기능은 구현중이에요. 다음 업데이트를 기다려주세요.",
                message: "",
                okActionTitle: "OK",
                okActionHandler: nil,
                cancelActionTitle: "",
                cancelActionHandler: nil
            )
        }
        cell.delegate = self
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension PostingMainViewController: TableViewCellDelegate {
    func iconButtonAnimationIsClosed(reaction: ReactionType) {
        getMyStoryResponse()
    }
    
    private func toastButtonAnimate(reaction: ReactionType) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        let toastLabel = ToastLabel()
        toastLabel.setupUI(text: reaction.toastMessageTitle)
        
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
    case error
    
    var BackgroundimageView: UIImage? {
        switch self {
        case .dataExit: return UIImage(named: "img_list_bg")
        case .error: return UIImage(named: "img_list_error_bg_posting")
        }
    }
}

enum StoryType {
    case allStory
    case myStory
}
