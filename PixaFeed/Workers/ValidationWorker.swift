//
//  ValidationWorker.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

protocol Validator {
    func validate(_ value: Any?) throws
}

enum ValidationError: Error {
    case invalidEmail
    case invalidPasswordLength
    case invalidAgeRange

    var errorMessage: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPasswordLength:
            return "Password must be between 6 and 12 characters."
        case .invalidAgeRange:
            return "Age must be between 18 and 99."
        }
    }
}

class EmailValidator: Validator {
    func validate(_ value: Any?) throws {
        guard let email = value as? String else {
            throw ValidationError.invalidEmail
        }
        
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        if !emailPredicate.evaluate(with: email) {
            throw ValidationError.invalidEmail
        }
    }
}

class PasswordValidator: Validator {
    func validate(_ value: Any?) throws {
        guard let password = value as? String, password.count >= 6 && password.count <= 12 else {
            throw ValidationError.invalidPasswordLength
        }
    }
}

class AgeValidator: Validator {
    func validate(_ value: Any?) throws {
        guard let age = value as? Int, age >= 18 && age <= 99 else {
            throw ValidationError.invalidAgeRange
        }
    }
}

protocol ValidationWorker {
    func validate(values: [String: Any]) throws
}

class UserValidationWorker: ValidationWorker {
    private let emailValidator: Validator
    private let passwordValidator: Validator
    private let ageValidator: Validator

    init(emailValidator: Validator, passwordValidator: Validator, ageValidator: Validator) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.ageValidator = ageValidator
    }

    func validate(values: [String: Any]) throws {
        if let email = values["email"] as? String {
            try emailValidator.validate(email)
        }
        if let age = values["age"] as? Int {
            try ageValidator.validate(age)
        }
        if let password = values["password"] as? String {
            try passwordValidator.validate(password)
        }
    }
}

class LoginValidationWorker: ValidationWorker {
    private let emailValidator: Validator
    private let passwordValidator: Validator

    init(emailValidator: Validator, passwordValidator: Validator) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }

    func validate(values: [String: Any]) throws {
        if let email = values["email"] as? String {
            try emailValidator.validate(email)
        }
        if let password = values["password"] as? String {
            try passwordValidator.validate(password)
        }
    }
}
