//
//  HomeFeedItem.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import Foundation

enum HomeFeedSection: Int, CaseIterable {
    case image
    case loading
    
    var identifier: String {
        switch self {
        case .image: return HomeCell.reuseIdentifier
        case .loading: return LoadingCell.reuseIdentifier
        }
    }
}
