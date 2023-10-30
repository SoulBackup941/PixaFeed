//
//  ImageFeedCell.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import UIKit
import Kingfisher

class HomeCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageFeedCell"
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var userLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        userLabel.text = nil
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(userLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: userLabel.topAnchor, constant: -8),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            userLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            userLabel.leftAnchor.constraint(equalTo: leftAnchor),
            userLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func configure(with imageURL: URL?, user: String?) {
        imageView.kf.setImage(with: imageURL)
        userLabel.text = user
    }
}
