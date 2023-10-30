//
//  ImageDetailViewController.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//


import UIKit
import Combine
import Kingfisher

class ImageDetailViewController: UIViewController {
    
    private let viewModel: ImageDetailViewModel
    private var viewModelCancellables: Set<AnyCancellable> = []
    var coordinator: ImageDetailCoordinator?
    var subscriptions: Set<AnyCancellable> = []
    // MARK: - Section 1 UI Components
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()

    
    private lazy var imageSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Section 2 UI Components
    private lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "User Information"
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomPlaceholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    
    private lazy var likesLabel: UILabel = createInfoLabel()
    private lazy var commentsLabel: UILabel = createInfoLabel()
    private lazy var favoritesLabel: UILabel = createInfoLabel()
    private lazy var downloadsLabel: UILabel = createInfoLabel()
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelBindings()
        viewModel.loadImageDetails()
    }
    
    private func displayImageDetail(_ detail: ImageDetailModel) {
        loadImage(from: detail.imageURL)
        displayImageProperties(using: detail)
        displayUserInteractions(using: detail)
        displayUserInfo(userName: detail.userName)
    }
    
    private func loadImage(from url: URL?) {
        imageView.kf.setImage(with: url)
    }

    private func displayImageProperties(using detail: ImageDetailModel) {
        imageSizeLabel.text = detail.imageSizeDescription
        imageTypeLabel.text = detail.imageTypeDescription
        layoutTags(detail.tags)
    }

    private func displayUserInteractions(using detail: ImageDetailModel) {
        likesLabel.text = "Likes: \(detail.likesCount)"
        commentsLabel.text = "Comments: \(detail.commentsCount)"
        favoritesLabel.text = "Favorites: \(detail.favoritesCount)"
        downloadsLabel.text = "Downloads: \(detail.downloadsCount)"
    }

    private func displayUserInfo(userName: String) {
        userInfoLabel.text = userName
    }
}

// MARK: - Setup UI

extension ImageDetailViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        addSubviews()
        setupConstraints()
        setupLongPressGesture()
        setupStyling()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func addSubviews() {
        [imageView, imageSizeLabel, imageTypeLabel, tagsStackView,
         userInfoLabel, likesLabel, commentsLabel, favoritesLabel, downloadsLabel, bottomPlaceholderView]
            .forEach(contentView.addSubview)
    }
    
    private func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        imageView.addGestureRecognizer(longPressRecognizer)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupStyling() {
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        imageSizeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        imageTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        userInfoLabel.textColor = .label
        likesLabel.textColor = .secondaryLabel
        commentsLabel.textColor = .secondaryLabel
        favoritesLabel.textColor = .secondaryLabel
        downloadsLabel.textColor = .secondaryLabel
    }
    
    private func setupConstraints() {
        let marginGuide = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            imageSizeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            imageSizeLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            imageTypeLabel.topAnchor.constraint(equalTo: imageSizeLabel.bottomAnchor, constant: 15),
            imageTypeLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            tagsStackView.topAnchor.constraint(equalTo: imageTypeLabel.bottomAnchor, constant: 15),
            tagsStackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            tagsStackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            
            userInfoLabel.topAnchor.constraint(equalTo: tagsStackView.bottomAnchor, constant: 40),
            userInfoLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            likesLabel.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 25),
            likesLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            commentsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 15),
            commentsLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            favoritesLabel.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 15),
            favoritesLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            downloadsLabel.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 20),
            downloadsLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            
            bottomPlaceholderView.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 20),
            bottomPlaceholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomPlaceholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomPlaceholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomPlaceholderView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
}

// MARK: Bindings

extension ImageDetailViewController {
    func bindViewModel() {
        viewModel.imageURLToShare
            .sink { [weak self] imageURL in
                guard let self, let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
                self.coordinator?.presentShareActivity(with: image)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UI Helper methods
extension ImageDetailViewController {
    private func createInfoLabel() -> UILabel {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.backgroundColor = .systemGray5
        return label
    }
    
    // TODO: Refactor to CollectionView for better UI/UX
    private func layoutTags(_ tags: [String]) {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tag in tags {
            let label = PaddedLabel()
            label.text = tag
            label.backgroundColor = .systemGray4
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            tagsStackView.addArrangedSubview(label)
        }
        tagsStackView.axis = tagsStackView.subviews.count > 3 ? .vertical : .horizontal
    }
}

// MARK: - Setup bindings
extension ImageDetailViewController {
    func setupViewModelBindings() {
        viewModel.imageDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.displayImageDetail(detail)
            }
            .store(in: &viewModelCancellables)
        viewModel.imageURLToShare
            .sink { [weak self] imageURLString in
                self?.presentSheet(urlString: imageURLString)
            }
            .store(in: &subscriptions)
    }
    
    private func presentSheet(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.coordinator?.presentShareActivity(with: imageResult.image)
            case .failure(_):
                break
            }
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewModel.handleLongPress()
        }
    }
}
