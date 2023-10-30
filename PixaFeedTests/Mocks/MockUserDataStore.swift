//
//  MockUserDataStore.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation
@testable import PixaFeed

class MockUserDataStore: UserDataStore {
    var isSaveCalled = false
    var shouldFail = false
    var errorType: DataStoreError = .writeError 

    func save(user: UserRegistration) async throws {
        isSaveCalled = true

        if shouldFail {
            throw errorType
        }
    }
}
