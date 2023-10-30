//
//  HomeFeed.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

// MARK: - PixabayResponse
struct PixabayResponse: Codable {
    let total, totalHits: Int
    let hits: [PixabayImage]
}

// MARK: - Hit
struct PixabayImage: Codable {
    let id: Int
    let pageURL: String
    let type: PixabayImageType
    let tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, collections, likes, comments: Int
    let userID: Int
    let user: String
    let userImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
}

enum PixabayImageType: String, Codable {
    case illustration = "illustration"
    case photo = "photo"
    case vectorSvg = "vector/svg"
}

// Helps for testing
extension PixabayImage: Equatable {
    static func == (lhs: PixabayImage, rhs: PixabayImage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.pageURL == rhs.pageURL &&
               lhs.type == rhs.type &&
               lhs.tags == rhs.tags &&
               lhs.previewURL == rhs.previewURL &&
               lhs.previewWidth == rhs.previewWidth &&
               lhs.previewHeight == rhs.previewHeight &&
               lhs.webformatURL == rhs.webformatURL &&
               lhs.webformatWidth == rhs.webformatWidth &&
               lhs.webformatHeight == rhs.webformatHeight &&
               lhs.largeImageURL == rhs.largeImageURL &&
               lhs.imageWidth == rhs.imageWidth &&
               lhs.imageHeight == rhs.imageHeight &&
               lhs.imageSize == rhs.imageSize &&
               lhs.views == rhs.views &&
               lhs.downloads == rhs.downloads &&
               lhs.collections == rhs.collections &&
               lhs.likes == rhs.likes &&
               lhs.comments == rhs.comments &&
               lhs.userID == rhs.userID &&
               lhs.user == rhs.user &&
               lhs.userImageURL == rhs.userImageURL
    }
}
