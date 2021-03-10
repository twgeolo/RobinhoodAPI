//
//  RobinhoodClient.swift
//  StockBrokerKit
//
//  Created by George Lo on 3/5/21.
//

import Foundation
import Combine

@available(iOS 13, macOS 11.0, tvOS 13, watchOS 6.0, *)
public class RobinhoodClient {

    let username: String
    let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    let APIHost = "https://api.robinhood.com/"

    @Published var lastAuthSuccessResponse: AuthSuccessResponse?

}