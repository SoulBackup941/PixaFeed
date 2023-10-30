//
//  RegistrationViewModel.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation
import Combine

protocol RegistrationViewModelProtocol {
    func register(email: String, age: Int, password: String) throws
    var navigateToAction: AnyPublisher<NavigationAction, Never> { get }
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    private let navigateSubject = PassthroughSubject<NavigationAction, Never>()
    var navigateToAction: AnyPublisher<NavigationAction, Never> {
        navigateSubject.eraseToAnyPublisher()
    }
    
    private let registerUser: RegisterUserUseCase
    private let validationWorker: ValidationWorker

    init(registerUser: RegisterUserUseCase, validationWorker: ValidationWorker) {
        self.registerUser = registerUser
        self.validationWorker = validationWorker
    }
    
    func register(email: String, age: Int, password: String) throws {
        
        let values = ["email": email, "age": age, "password": password] as [String : Any]
        try validationWorker.validate(values: values)
        
        let hashedPassword = password.sha256()
        let user = UserRegistration(email: email, age: age, password: hashedPassword)
        
        // Proceed with registration if validation is successful
        try registerUser.execute(user: user)
        navigateSubject.send(.home)
    }
}
