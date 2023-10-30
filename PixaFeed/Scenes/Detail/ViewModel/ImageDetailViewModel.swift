//
//  ImageDetailViewModel.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import Foundation
import Combine

class ImageDetailViewModel {
    
    private let image: PixabayImage
    let imageDetail: PassthroughSubject<ImageDetailModel, Never> = PassthroughSubject<ImageDetailModel, Never>()
    let imageURLToShare: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
    
    init(image: PixabayImage) {
        self.image = image
    }
    
    func loadImageDetails() {
        let detailModel = ImageDetailModel(
            imageURL: URL(string: image.largeImageURL),
            imageSizeDescription: "\(image.imageWidth) x \(image.imageHeight)",
            imageTypeDescription: image.type.rawValue,
            tags: image.tags.components(separatedBy: ", "),
            userName: image.user,
            userImageURL: URL(string: image.userImageURL),
            likesCount: "\(image.likes)",
            commentsCount: "\(image.comments)",
            favoritesCount: "\(image.collections)",
            downloadsCount: "\(image.downloads)"
        )
        
        imageDetail.send(detailModel)
    }
    
    func handleLongPress() {
        self.imageURLToShare.send(image.largeImageURL)
    }
}
