//
//  RobinhoodAPI+PropertyWrappers.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/8/21.
//

import Foundation

extension URL: LosslessStringConvertible {

    public init?(_ description: String) {
        guard let url = URL(string: description) else { return nil }
        self = url
    }

}

extension Date: LosslessStringConvertible {

    public init?(_ description: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: description) {
            self = date
        } else {
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: description) else { return nil }
            self = date
        }
    }

}

public typealias CLSC = Codable & LosslessStringConvertible

@propertyWrapper
public struct SafeValue<T: CLSC>: Codable, CustomStringConvertible {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        var value: T
        do {
            value = try container.decode(T.self)
        } catch {
            value = T(try container.decode(String.self))!
        }

        self.wrappedValue = value
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }

    public var description: String {
        String(describing: wrappedValue)
    }
}

@propertyWrapper
public struct SafeOptionalValue<T: CLSC>: Codable, CustomStringConvertible {

    public var wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        var value: T?
        do {
            value = try container.decode(T.self)
        } catch {
            do {
                value = T(try container.decode(String.self))
            } catch {
                _ = container.decodeNil()
            }
        }

        self.wrappedValue = value
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }

    public var description: String {
        if let value = wrappedValue {
            return String(describing: value)
        } else {
            return "nil"
        }
    }
}
