//
//  LoginUseCase.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws
}

class LoginUseCase: LoginUseCaseProtocol {
    private let repository: UserLoginRepositoryProtocol

    init(repository: UserLoginRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws {
        // Perform the login operation using the repository
        try await repository.login(email: email, password: password)
    }
}
