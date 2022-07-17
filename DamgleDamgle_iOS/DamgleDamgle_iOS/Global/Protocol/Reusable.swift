//
//  Reusable.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/14.
//

import UIKit

protocol Reusable: AnyObject {
    static var reusableIdentifier: String { get }
}

extension Reusable where Self: UIView {
    static var reusableIdentifier: String {
        String(describing: self)
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Self.reusableIdentifier, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }

    func setupUIFromNib(_ setAutoResizingMask: Bool = true) {
        guard let contentView = loadViewFromNib() else {
            return
        }
        contentView.frame = bounds

        if setAutoResizingMask {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        backgroundColor = .clear
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a cell with identifier: \(T.reusableIdentifier)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reusableIdentifier) as? T else {
            fatalError("Could not dequeue a HeaderFooter with identifier: \(T.reusableIdentifier)")
        }

        return view
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a cell with identifier: \(T.reusableIdentifier)")
        }

        return cell
    }
}

extension UICollectionViewFlowLayout {
    func registerDecorationView<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)
        register(nib, forDecorationViewOfKind: T.reusableIdentifier)
    }
}

extension UICollectionViewCompositionalLayout {
    // XIB를 직접 등록하는 경우
    func registerDecorationView<T: UICollectionReusableView>(fromXib _: T.Type) where T: Reusable {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)

        register(nib, forDecorationViewOfKind: T.reusableIdentifier)
    }

    func registerDecorationView<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        register(T.self, forDecorationViewOfKind: T.reusableIdentifier)
    }
}
