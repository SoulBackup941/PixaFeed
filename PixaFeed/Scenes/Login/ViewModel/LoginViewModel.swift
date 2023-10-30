//
//  LoginViewModel.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import Foundation
import Combine

protocol LoginViewModelProtocol {
    var statePublisher: AnyPublisher<LoginViewModel.ViewModelState, Never> { get }
    var navigateToAction: AnyPublisher<NavigationAction, Never> { get }
    func didTapLogin(with email: String, password: String)
    func didTapRegistrataion()
}

class LoginViewModel: LoginViewModelProtocol {
    
    enum ViewModelState {
        case idle
        case loading
        case success
        case failure(Error)
    }

    var statePublisher: AnyPublisher<ViewModelState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    private let navigateSubject = PassthroughSubject<NavigationAction, Never>()
    
    var navigateToAction: AnyPublisher<NavigationAction, Never> {
        navigateSubject.eraseToAnyPublisher()
    }

    private let loginValidationWorker: LoginValidationWorker
    private let stateSubject = PassthroughSubject<ViewModelState, Never>()
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginValidationWorker: LoginValidationWorker, loginUseCase: LoginUseCase) {
        self.loginValidationWorker = loginValidationWorker
        self.loginUseCase = loginUseCase
    }

    func didTapLogin(with email: String, password: String) {
        // Here, instead of relying on VC to hide error labels,
        // We can also introduce states like .emailError and .passwordError
        // to handle individual errors for a more fine-grained UI control
        stateSubject.send(.loading)  // Indicate loading state

        Task {
            do {
                try await performLogin(email: email, password: password)
                stateSubject.send(.success)  // Success state
            } catch {
                stateSubject.send(.failure(error))  // Failure state
            }
        }
    }
    
    func didTapRegistrataion() {
        navigateSubject.send(.registration)
    }

    private func performLogin(email: String, password: String) async throws {
        try loginValidationWorker.validate(values: ["email": email, "password": password])
        let hashedPassword = password.sha256()
        try await loginUseCase.execute(email: email, password: hashedPassword)
    }
}
