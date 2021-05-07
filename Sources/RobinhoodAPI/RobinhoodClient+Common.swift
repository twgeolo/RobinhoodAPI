//
//  RobinhoodClient+Common.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/9/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct PaginatedResponse<T: Codable>: Codable, RobinhoodAPIStructStringConvertible {
        @SafeOptionalValue public var next: URL?
        @SafeOptionalValue public var previous: URL?
        public let results: [T]
    }
    
    func allResultsPublisher<T: Codable>(for response: PaginatedResponse<T>) -> AnyPublisher<[T], Error> {
        func publisher(url: URL) -> AnyPublisher<PaginatedResponse<T>, Error> {
            return getRequestPublisher(
                token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
                url: url
            )
            .map { $0.data }
            .decode(type: PaginatedResponse<T>.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        }
        func recurse(url: URL) -> AnyPublisher<[T], Error> {
            return publisher(url: url)
                .flatMap { response -> AnyPublisher<[T], Error> in
                    if let next = response.next {
                        return recurse(url: next)
                            .map { nextResponse in
                                return response.results + nextResponse
                            }
                            .eraseToAnyPublisher()
                    } else {
                        return Just(response.results)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
        if let next = response.next {
            return recurse(url: next)
        } else {
            return Just(response.results)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func allResultsPublisher<T: Codable>(for publisher: AnyPublisher<PaginatedResponse<T>, Error>) -> AnyPublisher<[T], Error> {
        return publisher
            .flatMap { [weak self] response -> AnyPublisher<[T], Error> in
                guard let strongSelf = self else {
                    return Just(response.results)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return strongSelf.allResultsPublisher(for: response)
            }
            .eraseToAnyPublisher()
    }

}
