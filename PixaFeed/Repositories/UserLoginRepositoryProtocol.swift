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

    init(remote: UserDataStore) {
        self.remoteDataStore = remote
    }

    func login(email: String, password: String) async throws {
        
    }
}
