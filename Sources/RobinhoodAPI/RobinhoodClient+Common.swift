//
//  RobinhoodClient+Common.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/9/21.
//

import Foundation

public extension RobinhoodClient {

    struct PaginatedResponse<T: Codable>: Codable {
        @SafeOptionalValue var next: URL?
        @SafeOptionalValue var previous: URL?
        public let results: [T]
    }

}
