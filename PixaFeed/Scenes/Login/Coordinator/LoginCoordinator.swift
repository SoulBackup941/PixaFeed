//
//  LoginCoordinator.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import UIKit

class LoginCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let loginValidationWorker = LoginValidationWorker(emailValidator: emailValidator, passwordValidator: passwordValidator)
        let mockAPIClient = MockAPIClient()
        let loginRepository = UserLoginRepository(remote: mockAPIClient)
        let loginUseCase = LoginUseCase(repository: loginRepository)
        let viewModel = LoginViewModel(loginValidationWorker: loginValidationWorker, loginUseCase: loginUseCase)
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: true)
    }

    func navigateToRegistration() {
        let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController)
        registrationCoordinator.start()
    }
    
    func navigateToHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
}
