//
//  LoadingIndicatorView.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import UIKit

class LoadingIndicatorView: UIView {
    private var activityIndicator: UIActivityIndicatorView

    override init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(frame: frame)

        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(coder: coder)

        setupActivityIndicator()
    }

    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
