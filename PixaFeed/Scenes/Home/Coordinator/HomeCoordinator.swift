//
//  HomeCoordinator.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import UIKit

class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let api = HomeRemoteDataSource()
        let db = ImageFeedLocalDataSource()
        let fetchImageRepository = ImageFeedRepository(remote: api, local: db)
        let fetchImageUseCase = FetchImageFeedUseCase(repository: fetchImageRepository)
        let homeVM = HomeViewModel(useCase: fetchImageUseCase)
        let homeVC = HomeFeedController(viewModel: homeVM)
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func navigateToDetail(with image: PixabayImage) {
        let detailCoordinator = ImageDetailCoordinator(navigationController: navigationController, pixaBayImage: image)
        detailCoordinator.start()
    }
}
