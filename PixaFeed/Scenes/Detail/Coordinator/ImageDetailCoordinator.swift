//
//  DetailCoordinator.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import UIKit

class ImageDetailCoordinator: Coordinator {
    let navigationController: UINavigationController
    let pixaBayImage: PixabayImage
    
    init(navigationController: UINavigationController, pixaBayImage: PixabayImage) {
        self.navigationController = navigationController
        self.pixaBayImage = pixaBayImage
    }

    func start() {
        let viewModel = ImageDetailViewModel(image: pixaBayImage)
        let imageDetailVC = ImageDetailViewController(viewModel: viewModel)
        
        imageDetailVC.coordinator = self
        navigationController.pushViewController(imageDetailVC, animated: true)
    }
    
    func presentShareActivity(with image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        navigationController.present(activityVC, animated: true, completion: nil)
    }
}
