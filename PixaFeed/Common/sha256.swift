//
//  sha256.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import Foundation
import CommonCrypto

extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
