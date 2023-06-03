//
//  Toast.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/31.
//

import UIKit

final class Toast: NSObject {

    private static let shared = Toast()

    private var appearedToasts = Set<ToastView>()

    private lazy var containerView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.isUserInteractionEnabled = false
        return view
    }()

    static func show(message: String?, seconds: Double = 2.0) {
        DispatchQueue.main.async {
            Toast.shared.show(message: message, seconds: seconds)
        }
    }
    
    private func show(message: String?, seconds: Double) {
        guard let message = message else {
            return
        }

        let toastView = ToastView(frame: .zero)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.isUserInteractionEnabled = false
        toastView.alpha = 0
        toastView.backgroundColor = UIColor(named: "grey1000") ?? .black

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)

        // Add the label
        toastView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 24.0).isActive = true
        label.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -24.0).isActive = true
        label.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 12.0).isActive = true
        label.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -12.0).isActive = true

        // Add the toast
        containerView.addSubview(toastView)
        toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        toastView.bottomConstraint = toastView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -64.0)
        toastView.bottomConstraint?.isActive = true

        DispatchQueue.main.async { [weak self] in
            self?.appearedToasts.reversed().forEach { self?.dismiss(toastView: $0) }
            self?.present(toastView: toastView, seconds: seconds)
        }
    }

    private func present(toastView: ToastView, seconds: Double) {
        if appearedToasts.isEmpty, containerView.superview == nil {
            guard let first = UIApplication.shared.windows.first else {
                return
            }
            first.addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: first.leadingAnchor, constant: 25.0).isActive = true
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: first.trailingAnchor, constant: -25.0).isActive = true
            containerView.centerXAnchor.constraint(equalTo: first.centerXAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: first.bottomAnchor).isActive = true
        }

        appearedToasts.insert(toastView)

        containerView.layoutIfNeeded()

        toastView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            toastView.alpha = 1.0
        } completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self?.dismiss(toastView: toastView)
            }
        }
    }

    private func dismiss(toastView: ToastView?) {
        guard let toastView = toastView, let index = appearedToasts.firstIndex(of: toastView) else { return }
        appearedToasts.remove(at: index)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            toastView.alpha = 0
        } completion: { _ in
            DispatchQueue.main.async { [weak self] in
                toastView.removeFromSuperview()
                guard self?.appearedToasts.isEmpty == true, self?.containerView.superview != nil else { return }
                self?.containerView.removeFromSuperview()
            }
        }
    }
}
