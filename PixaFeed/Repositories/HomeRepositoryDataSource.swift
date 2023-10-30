//
//  HomeRepository.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func fetchImageFeedFromAPI(page: Int) async throws -> PixabayResponse
}

protocol HomeLocalDataSourceProtocol {
    func fetchCachedImageFeed() async throws -> PixabayResponse
    func saveImageFeedToCache(_ response: PixabayResponse)
}

class HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    private static let apiURL = URL(string: "https://pixabay.com/api/")!
    private static let apiKey = "40318547-9e5445021545f116fc1454e71"

    enum DataSourceError: Error {
        case invalidServerResponse
    }

    func fetchImageFeedFromAPI(page: Int) async throws -> PixabayResponse {
        var urlComponents = URLComponents(url: HomeRemoteDataSource.apiURL, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: HomeRemoteDataSource.apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        print("Fetching from URL: \(urlComponents.url?.absoluteString ?? "N/A")")
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataSourceError.invalidServerResponse
        }
        
        return try JSONDecoder().decode(PixabayResponse.self, from: data)
    }
}

class ImageFeedLocalDataSource: HomeLocalDataSourceProtocol {
    private var cache: PixabayResponse?

    func fetchCachedImageFeed() async throws -> PixabayResponse {
        if let cachedData = cache {
            return cachedData
        } else {
            throw DataStoreError.dataInvalid
        }
    }

    func saveImageFeedToCache(_ response: PixabayResponse) {
        cache = response
    }
}
