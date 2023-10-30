//
//  RegisterUseCase.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

protocol RegisterUserUseCase {
    func execute(user: UserRegistration) throws
}

class RegisterUser: RegisterUserUseCase {
    private let repository: UserRegistrationRepositoryProtocol
    
    init(repository: UserRegistrationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(user: UserRegistration) throws {
        
    }
}
