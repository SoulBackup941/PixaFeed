//
//  ImageDetail.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import Foundation

struct ImageDetailModel {
    let imageURL: URL?
    let imageSizeDescription: String
    let imageTypeDescription: String
    let tags: [String]
    let userName: String
    let userImageURL: URL?
    let likesCount: String
    let commentsCount: String
    let favoritesCount: String
    let downloadsCount: String
}
