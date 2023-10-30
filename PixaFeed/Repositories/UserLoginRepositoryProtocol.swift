//
//  UserLoginRepositoryProtocol.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import Foundation

protocol UserLoginRepositoryProtocol {
    func login(email: String, password: String) async throws
}

class UserLoginRepository: UserLoginRepositoryProtocol {
    private let remoteDataStore: UserDataStore
    // You might not need a localDataStore for login, depending on your app's architecture

    init(remote: UserDataStore) {
        self.remoteDataStore = remote
    }

    func login(email: String, password: String) async throws {
        // Perform login operations, like sending credentials to a remote server
        // Depending on your server's response, you can throw errors if login fails
    }
}
