//
//  HomeFeedViewController.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import UIKit
import Combine

class HomeFeedController: UIViewController {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return collectionView
    }()
    
    // MARK: - Properties
    private var viewModel: HomeViewModel
    private var currentPage: Int = 1
    private var viewModelCancellables: Set<AnyCancellable> = []
    var coordinator: HomeCoordinator?
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PixaFeed"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupViews()
        setupViewModelBindings()
        viewModel.viewDidLoad()
    }
    
    @objc private func refresh() {
        viewModel.viewDidLoad()
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: Setup UI

extension HomeFeedController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.reuseIdentifier)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
    }
}

// MARK: Setup Bindings

extension HomeFeedController {
    private func setupViewModelBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &viewModelCancellables)
        viewModel.selectedImagePublisher
            .sink { [weak self] image in
                self?.navigateToDetail(with: image)
            }
            .store(in: &viewModelCancellables)
    }
    
    private func handle(state: HomeViewModel.ViewModelState) {
        switch state {
        case .loading:
            // TODO: Show loading indicator
            break
        case .loaded(let newImages):
            insertNewItems(from: newImages)
        case .error(let error):
            // TODO: Show error to the user
            print(error)
        case .initial:
            break
        }
    }
}

// MARK: Private methods

extension HomeFeedController {
    
    private func navigateToDetail(with image: PixabayImage) {
        coordinator?.navigateToDetail(with: image)
    }
    
    private func insertNewItems(from newImages: [PixabayImage]) {
        let currentItemCount = collectionView.numberOfItems(inSection: 0)
        let newItemsCount = newImages.count - currentItemCount
        let indexPathsToInsert = (currentItemCount..<currentItemCount + newItemsCount).map { IndexPath(item: $0, section: 0) }
        
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPathsToInsert)
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeFeedController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sectionType(for: indexPath.section)
        
        switch sectionType {
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseIdentifier, for: indexPath) as! HomeCell
            if let pixabayImage = viewModel.imageForSection(indexPath.row) {
                let url = URL(string: pixabayImage.previewURL)
                cell.configure(with: url, user: pixabayImage.user)
            }
            return cell
        case .loading:
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
            return loadingCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeFeedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.cellWillDisplay(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeFeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = viewModel.sectionType(for: indexPath.section)
        switch cellType {
        case .loading:
            let sectionInsets = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
            let totalWidth = collectionView.frame.width - sectionInsets.left - sectionInsets.right
            return CGSize(width: totalWidth, height: 50)
        case .image:
            let paddingSpace: CGFloat = 30
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / 2
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10.0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10.0 }
}
