//
//  RegistrationViewModelTests.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//

import XCTest
@testable import PixaFeed

class RegistrationViewModelTests: XCTestCase {
    
    var viewModel: RegistrationViewModelProtocol!
    var mockRegisterUser: MockRegisterUserUseCase!
    var mockValidationWorker: MockValidationWorker!

    override func setUp() {
        super.setUp()
        mockRegisterUser = MockRegisterUserUseCase()
        mockValidationWorker = MockValidationWorker()
        viewModel = RegistrationViewModel(registerUser: mockRegisterUser, validationWorker: mockValidationWorker)
    }

    override func tearDown() {
        viewModel = nil
        mockRegisterUser = nil
        mockValidationWorker = nil
        super.tearDown()
    }

    func testRegisterUserWithValidInput() {
        // Given
        let email = "test@example.com"
        let age = 25
        let password = "password123"
        
        // When
        XCTAssertNoThrow(try viewModel.register(email: email, age: age, password: password))
        
        // Then
        XCTAssertTrue(mockRegisterUser.isExecuteCalled, "Registration use case is not called")
        XCTAssertTrue(mockValidationWorker.isValidationCalled, "Validation worker is not called")
    }
}
