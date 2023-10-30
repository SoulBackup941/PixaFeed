//
//  HomeFeedRepository.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

protocol ImageFeedRepositoryProtocol {
    func fetchImageFeed(page: Int) async throws -> PixabayResponse
}

class ImageFeedRepository: ImageFeedRepositoryProtocol {
    let remoteDataSource: HomeRemoteDataSourceProtocol
    let localDataSource: HomeLocalDataSourceProtocol
    
    init(remote: HomeRemoteDataSourceProtocol, local: HomeLocalDataSourceProtocol) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }
    
    func fetchImageFeed(page: Int) async throws -> PixabayResponse {
        // Check the cache first
//        do {
//            let cachedData = try await localDataSource.fetchCachedImageFeed()
//            return cachedData
//        } catch {
            // If local cache retrieval fails or data is invalid, fetch from remote
            do {
                let remoteData = try await remoteDataSource.fetchImageFeedFromAPI(page: page)
                localDataSource.saveImageFeedToCache(remoteData)
                return remoteData
            } catch let remoteError {
                throw remoteError
            }
        }
    }




