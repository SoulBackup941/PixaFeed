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
        
    }
}

class MockDatabaseManager: UserDataStore {
    func save(user: UserRegistration) async throws {

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
        
        try await localDataStore.save(user: user)
        try await remoteDataStore.save(user: user)
    }
}
