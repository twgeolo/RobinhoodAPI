//
//  RobinhoodClient+Common.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/9/21.
//

import Foundation

public extension RobinhoodClient {

    struct PaginatedResponse<T: Codable>: Codable {
        @SafeOptionalValue public var next: URL?
        @SafeOptionalValue public var previous: URL?
        public let results: [T]
    }

}
