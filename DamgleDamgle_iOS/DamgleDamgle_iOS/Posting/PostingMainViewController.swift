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
    var storyType: StoryType = .myStory
    var sortingType: SortType = .time
    var viewModel = PostingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if storyType == .allStory {
            getFeedStoryResponse()
        }
        
        setupView()
    }
    
    private func setupView() {
        [timeSortButton, popularitySortButton].forEach { button in
            let title = button?.titleLabel!.text! ?? ""
            
            let normalFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
            let normalAttributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: normalFont])
            button?.setAttributedTitle(normalAttributedTitle, for: .normal)
            
            let selectedFont = UIFont(name: "Pretendard-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .bold)
            let selectedAttributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: selectedFont])
            button?.setAttributedTitle(selectedAttributedTitle, for: .selected)
        }
        
        if storyType == .myStory {
            timeSortButton.isHidden = true
            popularitySortButton.isHidden = true
            title = Strings.myStoryTitle
        }
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
        sortingType = .time
        
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
        sortingType = .popularity
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
            self.viewModel.sortPopularity()
            self.postingTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    @IBAction private func closeButtonDidTap(_ sender: UIBarButtonItem) {
        let myViewController = navigationController?.presentingViewController as? MyViewController
        dismiss(animated: true) {
            myViewController?.fetchMyStoryList()
        }
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
            cell.setupView()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
        let viewModel = self.viewModel.postModels?[indexPath.row]
        cell.delegate = self
        cell.setupUI(story: viewModel)
        
        cell.postReport = { [weak self] in
            guard let self = self, let id = viewModel?.id else { return }
            self.showAlertController(
                type: .double,
                title: Strings.reportTitle,
                message: Strings.reportSubTitle,
                okActionTitle: Strings.okReport,
                okActionHandler: {
                    self.viewModel.postReport(storyID: id) { isSuccess in
                        if isSuccess {
                            self.getFeedStoryResponse()
                        } else {
                            self.showAlertController(
                                type: .single,
                                title: PostStatus.fail.statusTitle,
                                message: PostStatus.fail.subTitle,
                                okActionTitle: Strings.confirm,
                                okActionHandler: nil,
                                cancelActionTitle: "",
                                cancelActionHandler: nil
                            )
                        }
                    }
                },
                cancelActionTitle: Strings.cancelReport
            )
        }
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension PostingMainViewController: TableViewCellDelegate {
    func endReactionButtonAnimation(reaction: ReactionType, wasEmpty: Bool, isChange: Bool, storyID: String) {
        if storyType == .myStory {
            viewModel.getMyStory(size: 300, storyID: nil) { [weak self] isSuccess in
                guard let self = self else { return }
                self.apiState = isSuccess ? .dataExit : .error
            }
        } else if storyType == .allStory && sortingType == .time {
            viewModel.getStoryFeed() { [weak self] isSuccess in
                guard let self = self else { return }
                self.apiState = isSuccess ? .dataExit : .error
            }
        } else if storyType == .allStory && sortingType == .popularity {
            viewModel.getStoryDetail(id: storyID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let story):
                    self.viewModel.chageToNewStory(story: story)
                case .failure(let error):
                    // TODO: 실패했을때 대응방법 적용예정
                    print(error.localizedDescription)
                }
            }
        }
        
        guard isChange else { return }
               
        toastButtonAnimate(reaction: reaction, wasEmpty: wasEmpty, isEmpty: reaction == .none)
    }
    
    // wasEmpty = 이전에 리액션 한게 없어서 비어 있었음, isEmpty = 지금 같은 리액션을 눌러서 이제 비게 됨
    private func toastButtonAnimate(reaction: ReactionType, wasEmpty: Bool = false, isEmpty: Bool = false) {
        if wasEmpty {
            Toast.show(message: reaction.firstReactionTitle)
        } else if isEmpty {
            Toast.show(message: reaction.removeReactionTitle)
        } else {
            Toast.show(message: reaction.toastMessageTitle)
        }
    }
}

extension PostingMainViewController {
    enum Strings {
        static let reportTitle = "정말 이 글을 신고하실건가요?"
        static let reportSubTitle = "신고한 글은\n관리자가 확인하여 곧 처리할게요."
        static let okReport = "신고"
        static let cancelReport = "신고 취소"
        static let reportFail = "현재 네트워크 문제로 서비스 신고하기가 불가해요. 나중에 다시 시도해주세요."
        static let confirm = "확인"
        static let myStoryTitle = "내 담글 확인하기"
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

enum SortType {
    case time
    case popularity
}
