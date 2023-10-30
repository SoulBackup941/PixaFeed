//
//  UserRegistrationRepositoryTests.swift
//  PixaFeedTests
//
//  Created by Irakli Shelia on 27.10.23.
//

@testable import PixaFeed
import XCTest

class UserRegistrationRepositoryTests: XCTestCase {
    
    var remoteDataStore: MockUserDataStore!
    var localDataStore: MockUserDataStore!
    var repository: UserRegistrationRepository!
    
    override func setUp() {
        super.setUp()
        remoteDataStore = MockUserDataStore()
        localDataStore = MockUserDataStore()
        repository = UserRegistrationRepository(remote: remoteDataStore, local: localDataStore)
    }

    func testRegistrationSuccess() async {
        let user = UserRegistration(email: "test@example.com", age: 30, password: "password123")

        do {
            try await repository.register(user: user)
            XCTAssertTrue(localDataStore.isSaveCalled)
            XCTAssertTrue(remoteDataStore.isSaveCalled)
        } catch {
            XCTFail("Registration should succeed.")
        }
    }

    func testLocalSaveFailure() async {
        let user = UserRegistration(email: "test@example.com", age: 30, password: "password123")
        localDataStore.shouldFail = true
        localDataStore.errorType = .writeError

        do {
            try await repository.register(user: user)
            XCTFail("Registration should fail due to local save failure.")
        } catch {
            XCTAssertEqual(error as? DataStoreError, .writeError)
        }
        XCTAssertTrue(localDataStore.isSaveCalled)
        XCTAssertFalse(remoteDataStore.isSaveCalled)
    }

    func testRemoteSaveFailure() async {
        let user = UserRegistration(email: "test@example.com", age: 30, password: "password123")
        localDataStore.shouldFail = false
        remoteDataStore.shouldFail = true
        remoteDataStore.errorType = .serverError

        do {
            try await repository.register(user: user)
            XCTFail("Registration should fail due to remote save failure.")
        } catch {
            XCTAssertEqual(error as? DataStoreError, .serverError)
        }
        XCTAssertTrue(localDataStore.isSaveCalled)
        XCTAssertTrue(remoteDataStore.isSaveCalled)
    }

    
    override func tearDown() {
        remoteDataStore = nil
        localDataStore = nil
        repository = nil
        super.tearDown()
    }
}
