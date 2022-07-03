//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit
import RxSwift

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"

    private let onCountChanged: (Int) -> Void
    private let cellDisposeBag = DisposeBag()

    var disposeBag = DisposeBag()
    let onData: AnyObserver<PostModel>
//    let onChanged: Observable<Int>

    required init?(coder aDecoder: NSCoder) {
        let data = PublishSubject<PostModel>()
        let changing = PublishSubject<Int>()
        onCountChanged = { changing.onNext($0) }

        onData = data.asObserver()
//        onChanged = changing

        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in

                guard let self = self else { return }

                self.placeAddressLabel.text = model.placeAddress
                self.contentLabel.text = model.content
                self.timeLabel.text = model.time
                self.userNameLabel.text = model.userName

                if model.checkMyContent == true {
                    self.checkMeLabel.text = " • ME"
                } else {
                    self.checkMeLabel.text = ""
                }
            })
            .disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var checkMeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}
