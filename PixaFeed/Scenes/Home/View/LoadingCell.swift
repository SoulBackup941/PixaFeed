//
//  LoadingCell.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let reuseIdentifier = "LoadingCell"

    // MARK: - UI Components
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.startAnimating() // Ensure spinner is animating when cell is reused
    }

    // MARK: - Setup Views
    private func setupViews() {
        addSubview(spinner)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

