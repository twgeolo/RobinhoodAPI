//
//  RobinhoodClient.swift
//  StockBrokerKit
//
//  Created by George Lo on 3/5/21.
//

import Foundation
import Combine

let APIHost = "https://api.robinhood.com/"

@available(iOS 13, macOS 11.0, tvOS 13, watchOS 6.0, *)
public class RobinhoodClient {

    let username: String
    let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    internal struct AuthMetadata: Codable, Equatable {
        let accessToken: String
        let expiresIn: Date
    }

    private var _authMetadata: AuthMetadata?
    internal var authMetadata: AuthMetadata? {
        get {
            if _authMetadata == nil {
                guard let encoded = UserDefaults.standard.data(forKey: String(describing: AuthMetadata.self)),
                      let decoded = try? JSONDecoder().decode(AuthMetadata.self, from: encoded) else { return nil }
                _authMetadata = decoded
            }
            return _authMetadata
        }
        set {
            if _authMetadata != newValue {
                guard let encoded = try? JSONEncoder().encode(newValue) else { return }
                UserDefaults.standard.set(encoded, forKey: String(describing: AuthMetadata.self))
                _authMetadata = newValue
            }
        }
    }

}
