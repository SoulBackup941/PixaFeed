//
//  UserValidationWorkerTests.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//


import XCTest
@testable import PixaFeed

class EmailValidatorTests: XCTestCase {

    var emailValidator: EmailValidator!

    override func setUp() {
        super.setUp()
        emailValidator = EmailValidator()
    }

    override func tearDown() {
        emailValidator = nil
        super.tearDown()
    }

    func testValidEmail() {
        XCTAssertNoThrow(try emailValidator.validate("user@example.com"))
    }

    func testInvalidEmail() {
        XCTAssertThrowsError(try emailValidator.validate("userexample.com")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
}


class PasswordValidatorTests: XCTestCase {

    var passwordValidator: PasswordValidator!

    override func setUp() {
        super.setUp()
        passwordValidator = PasswordValidator()
    }

    override func tearDown() {
        passwordValidator = nil
        super.tearDown()
    }

    func testValidPassword() {
        XCTAssertNoThrow(try passwordValidator.validate("Password1"))
    }

    func testInvalidPasswordShort() {
        XCTAssertThrowsError(try passwordValidator.validate("Pass")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidPasswordLength)
        }
    }

    func testInvalidPasswordLong() {
        XCTAssertThrowsError(try passwordValidator.validate("ThisIsAVeryLongPassword")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidPasswordLength)
        }
    }
}

class AgeValidatorTests: XCTestCase {

    var ageValidator: AgeValidator!

    override func setUp() {
        super.setUp()
        ageValidator = AgeValidator()
    }

    override func tearDown() {
        ageValidator = nil
        super.tearDown()
    }

    func testValidAge() {
        XCTAssertNoThrow(try ageValidator.validate(25))
    }

    func testInvalidAgeYoung() {
        XCTAssertThrowsError(try ageValidator.validate(17)) { error in
            XCTAssertEqual(error as? ValidationError, .invalidAgeRange)
        }
    }

    func testInvalidAgeOld() {
        XCTAssertThrowsError(try ageValidator.validate(100)) { error in
            XCTAssertEqual(error as? ValidationError, .invalidAgeRange)
        }
    }
}

class UserValidationWorkerTests: XCTestCase {

    var validationWorker: UserValidationWorker!

    override func setUp() {
        super.setUp()
        validationWorker = UserValidationWorker(emailValidator: EmailValidator(), passwordValidator: PasswordValidator(), ageValidator: AgeValidator())
    }

    override func tearDown() {
        validationWorker = nil
        super.tearDown()
    }

    func testValidUser() {
        let values: [String: Any] = ["email": "user@example.com", "password": "Password1", "age": 25]
        XCTAssertNoThrow(try validationWorker.validate(values: values))
    }

    func testInvalidUser() {
        let values: [String: Any] = ["email": "userexample.com", "password": "Pass", "age": 17]
        XCTAssertThrowsError(try validationWorker.validate(values: values))
    }
}

class LoginValidationWorkerTests: XCTestCase {

    var loginValidationWorker: LoginValidationWorker!

    override func setUp() {
        super.setUp()
        loginValidationWorker = LoginValidationWorker(emailValidator: EmailValidator(), passwordValidator: PasswordValidator())
    }

    override func tearDown() {
        loginValidationWorker = nil
        super.tearDown()
    }

    func testValidLogin() {
        let values: [String: Any] = ["email": "user@example.com", "password": "Password1"]
        XCTAssertNoThrow(try loginValidationWorker.validate(values: values))
    }

    func testInvalidLogin() {
        let values: [String: Any] = ["email": "userexample.com", "password": "Pass"]
        XCTAssertThrowsError(try loginValidationWorker.validate(values: values))
    }
}


