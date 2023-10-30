//
//  MockValidationWorker.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//

@testable import PixaFeed

class MockValidationWorker: ValidationWorker {
    var isValidationCalled = false
    var validatedValues: [String: Any] = [:]

    func validate(values: [String: Any]) throws {
        isValidationCalled = true
        validatedValues = values
    }
}
