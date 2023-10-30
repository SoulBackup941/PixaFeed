//
//  MockRegisterUserUseCase.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//

@testable import PixaFeed

class MockRegisterUserUseCase: RegisterUserUseCase {
    var isExecuteCalled = false
    
    func execute(user: UserRegistration) throws {
        isExecuteCalled = true
        // You can add additional logic here if needed
    }
}
