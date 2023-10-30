//
//  HomeFeedViewModel.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var statePublisher: AnyPublisher<HomeViewModel.ViewModelState, Never> { get }
    var selectedImagePublisher: AnyPublisher<PixabayImage, Never> { get }
    
    func viewDidLoad()
    func cellWillDisplay(at index: Int)
    func didSelectItem(at index: Int)
    func sectionType(for section: Int) -> HomeFeedSection
    func numberOfItems(in section: Int) -> Int
    func numberOfSections() -> Int
}

class HomeViewModel: HomeViewModelProtocol {
    // MARK: - ViewModelState
    enum ViewModelState: Equatable {
        case initial
        case loading
        case loaded([PixabayImage])
        case error(Error)
        
        static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
               switch (lhs, rhs) {
               case (.initial, .initial), (.loading, .loading):
                   return true
               case (.loaded(let a), .loaded(let b)):
                   return a == b 
               case (.error(let a), .error(let b)):
                   return a.localizedDescription == b.localizedDescription
               default:
                   return false
               }
           }
    }
    
    // MARK: - Public Properties
    var statePublisher: AnyPublisher<ViewModelState, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    var selectedImagePublisher: AnyPublisher<PixabayImage, Never> {
        return selectedImageSubject.eraseToAnyPublisher()
    }
    
    private var numberOfImages: Int {
        switch state {
        case .loading:
            return allImages.count
        default:
            return allImages.count
        }
    }

    // MARK: - Private Properties
    private let fetchImageFeedUseCase: FetchImageFeedUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var state: ViewModelState = .initial {
        didSet {
            stateSubject.send(state)
        }
    }
    private var allImages: [PixabayImage] = []
    private let stateSubject = PassthroughSubject<ViewModelState, Never>()
    private let selectedImageSubject = PassthroughSubject<PixabayImage, Never>()
    private var currentPage: Int = 1

    // MARK: - Initializer
    init(useCase: FetchImageFeedUseCaseProtocol) {
        self.fetchImageFeedUseCase = useCase
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        fetchNextPage()
    }
    
    func didSelectItem(at index: Int) {
        if let image = imageForSection(index) {
            selectedImageSubject.send(image)
        }
    }
    
    func cellWillDisplay(at index: Int) {
        handlePrefetching(at: index)
    }
    
    func sectionType(for section: Int) -> HomeFeedSection {
        guard let sectionType = HomeFeedSection(rawValue: section) else {
            fatalError("Invalid section")
        }
        return sectionType
    }

    func numberOfSections() -> Int {
        HomeFeedSection.allCases.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        switch sectionType(for: section) {
        case .image:
            return allImages.count
        case .loading:
            return 1
        }
    }
    
    func imageForSection(_ section: Int) -> PixabayImage? {
        guard section < allImages.count else { return nil }
        return allImages[section]
    }

    // MARK: - Private Methods
    private func handlePrefetching(at index: Int) {
        if index == numberOfImages - 1 {
            switch state {
            case .loading:
                break
            default:
                fetchNextPage()
            }
        }
    }
    
    private func fetchNextPage() {
        if case .loading = state { return }
        state = .loading
        fetchImages(page: currentPage)
        currentPage += 1
    }

    private func fetchImages(page: Int) {
        Task { [weak self] in
            do {
                let response = try await self?.fetchImageFeedUseCase.execute(page: page)
                let newImages = response?.hits ?? []
                self?.allImages.append(contentsOf: newImages)
                self?.state = .loaded(self?.allImages ?? [])
            } catch {
                self?.state = .error(error)
            }
        }
    }
}
