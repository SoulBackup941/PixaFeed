//
//  RegistrationCoordinator.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import UIKit

class RegistrationCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let apiClient: UserDataStore = MockAPIClient()
        let databaseManager: UserDataStore = MockDatabaseManager()
        let registrationRepository: UserRegistrationRepositoryProtocol = UserRegistrationRepository(remote: apiClient, local: databaseManager)
        let registerUserUseCase = RegisterUser(repository: registrationRepository)
        let userValidationWorker = UserValidationWorker(emailValidator: EmailValidator(), passwordValidator: PasswordValidator(), ageValidator: AgeValidator())
        let registrationViewModel = RegistrationViewModel(registerUser: registerUserUseCase, validationWorker: userValidationWorker)
        let registrationVC = RegistrationViewController(viewModel: registrationViewModel)
        
        
        registrationVC.coordinator = self
        navigationController.pushViewController(registrationVC, animated: true)
    }
    
    func navigateToHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
}
