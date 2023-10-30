//
//  FetchImageFeedUseCase.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

protocol FetchImageFeedUseCaseProtocol {
    func execute(page: Int) async throws -> PixabayResponse
}

class FetchImageFeedUseCase: FetchImageFeedUseCaseProtocol {
    private let repository: ImageFeedRepositoryProtocol

    init(repository: ImageFeedRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> PixabayResponse {
        return try await repository.fetchImageFeed(page: page)
    }
}
