//
//  RegistrationRepository.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import Foundation

protocol UserDataStore {
    func save(user: UserRegistration) async throws
}


enum DataStoreError: Error {
    case dataInvalid
    case serverError
    case writeError
}

// --- Mock Implementations of Data Sources ---

class MockAPIClient: UserDataStore {
    func save(user: UserRegistration) async throws {
        // Mock: Simulate sending data to a remote server.
        // If there's an error, you would use: throw DataStoreError.someError
    }
}

class MockDatabaseManager: UserDataStore {
    func save(user: UserRegistration) async throws {
        // Mock: Simulate saving data to a local database.
        // If there's an error, you would use: throw DataStoreError.someError
    }
}


// --- User Registration Repository ---

protocol UserRegistrationRepositoryProtocol {
    func register(user: UserRegistration) async throws
}


class UserRegistrationRepository: UserRegistrationRepositoryProtocol {
    
    private let remoteDataStore: UserDataStore
    private let localDataStore: UserDataStore
    
    init(remote: UserDataStore, local: UserDataStore) {
        self.remoteDataStore = remote
        self.localDataStore = local
    }
    
    func register(user: UserRegistration) async throws {
        // Example flow: First save to local data store, then to remote.
        // This can be adjusted based on the exact business requirements.
        
        try await localDataStore.save(user: user)
        try await remoteDataStore.save(user: user)
    }
}
