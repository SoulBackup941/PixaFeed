//
//  ImageFeedViewModelTests.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 28.10.23.
//

import XCTest
import Combine
@testable import PixaFeed

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModelProtocol!
    var mockFetchImageFeedUseCase: MockFetchImageFeedUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockFetchImageFeedUseCase = MockFetchImageFeedUseCase()
        viewModel = HomeViewModel(useCase: mockFetchImageFeedUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockFetchImageFeedUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadedStateWithImageDataAfterViewDidLoad() {
        // Given
        let mockImages = [createMockImageData()]
        enqueueMockResponseWithImages(mockImages)
        
        // Create an expectation
        let receivedState = expectation(description: "Should receive the loaded state")
        
        // When
        viewModel.statePublisher
            .dropFirst()
            .sink(receiveValue: { state in
                if case .loaded(let images) = state {
                    XCTAssertEqual(images, mockImages, "Images do not match the mock images.")
                    receivedState.fulfill()
                }
            })
            .store(in: &cancellables)
        
        viewModel.viewDidLoad()
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSectionTypeReturnsCorrectSection() {
        // Given
        let sectionIndex = 1
        let expectedSection = HomeFeedSection(rawValue: sectionIndex)
        
        // When
        let returnedSection = viewModel.sectionType(for: sectionIndex)
        
        // Then
        XCTAssertEqual(returnedSection, expectedSection, "Returned section does not match the expected section.")
    }

    func testNumberOfSectionsReturnsCorrectCount() {
        // When
        let sectionCount = viewModel.numberOfSections()
        
        // Then
        XCTAssertEqual(sectionCount, HomeFeedSection.allCases.count, "Section count does not match the expected count.")
    }

    
    private func enqueueMockResponseWithImages(_ images: [PixabayImage]) {
        let mockResponse = createMockResponseWithImages(images)
        mockFetchImageFeedUseCase.mockResponse = mockResponse
    }
    
    
    private func createMockImageData() -> PixabayImage {
        PixabayImage(
            id: 1,
            pageURL: "http://example.com/pageURL",
            type: .photo,
            tags: "test, image",
            previewURL: "http://example.com/image1.jpg",
            previewWidth: 100,
            previewHeight: 100,
            webformatURL: "http://example.com/webformatURL",
            webformatWidth: 100,
            webformatHeight: 100,
            largeImageURL: "http://example.com/largeImageURL",
            imageWidth: 100,
            imageHeight: 100,
            imageSize: 5000,
            views: 1000,
            downloads: 500,
            collections: 50,
            likes: 250,
            comments: 25,
            userID: 12345,
            user: "TestUser",
            userImageURL: "http://example.com/userImageURL"
        )
    }
    
    private func createMockResponseWithImages(_ images: [PixabayImage]) -> PixabayResponse {
        PixabayResponse(total: images.count, totalHits: images.count, hits: images)
    }
}

class MockFetchImageFeedUseCase: FetchImageFeedUseCaseProtocol {
    var mockResponse: PixabayResponse?
    var mockError: Error?
    
    func execute(page: Int) async throws -> PixabayResponse {
        if let error = mockError {
            throw error
        }
        return mockResponse ?? PixabayResponse(total: 0, totalHits: 0, hits: [])
    }
}
