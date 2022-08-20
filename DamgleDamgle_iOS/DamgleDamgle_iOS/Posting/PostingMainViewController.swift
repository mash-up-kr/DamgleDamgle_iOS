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

    private var apiState: APIState = APIState.dataExit
    var viewModel = PostingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyStoryResponse()
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
    
//    private func getLocationAddress() {
//        let request = GeocodingRequest(
//            lat: locationManager.currentLocation.latitude,
//            lng: locationManager.currentLocation.longitude
//        )
//        
//        GeocodingService.reverseGeocoding(request: request) { result in
//            switch result {
//            case .success(let address):
//                self.currentAddressLabel.text = address
//            case .failure(let error):
//                self.currentAddressLabel.text = ""
//            }
//        }
//    }
    
    @IBAction private func timeSortingButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = true
        popularitySortButton.isSelected = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
            // TODO: MyStory 리스폰스값 서버에서 수정해서 보내주면 소팅함수 적용예정
            self.viewModel.sortTime()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    @IBAction private func popularitySortButtonTouchUp(_ sender: UIButton) {
        timeSortButton.isSelected = false
        popularitySortButton.isSelected = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
            // TODO: MyStory 리스폰스값 서버에서 수정해서 보내주면 소팅함수 적용예정
            self.viewModel.sortPopularity()
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
        return viewModel.postModels?.stories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if apiState == APIState.error {
            let cell = tableView.dequeueReusableCell(for: indexPath) as PostErrorTableViewCell
            cell.setupUI()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
        let viewModel = self.viewModel.postModels?.stories[indexPath.row]
        cell.setupUI(viewModel: viewModel)
        
        cell.addSelectedIcon = { [weak self] reaction in
            guard let self = self else { return }
            guard let id = viewModel?.id else { return }
            self.viewModel.postReaction(storyID: id, type: reaction.rawValue) { isSuccess in
                // TODO: 실패했을때 대응방법 적용예정
            }
        }
        cell.deleteSeletedIcon = { [weak self] in
            guard let self = self else { return }
            guard let id = viewModel?.id else { return }
            self.viewModel.deleteReaction(storyID: id) { isSuccess in
                // TODO: 실패했을때 대응방법 적용예정
            }
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
