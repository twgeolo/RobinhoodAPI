//
//  RobinhoodAPI+StringConvertible.swift
//  RobinhoodAPI
//
//  Created by George Lo on 5/6/21.
//

import Foundation

public protocol RobinhoodAPIStructStringConvertible: CustomStringConvertible {}

private func PrettyPrintedString(array: [Any], indentation: Int = 0) -> String {
    let indent = String(repeating: " ", count: indentation)
    var description = "["
    var isFirst = true
    for element in array {
        if isFirst {
            isFirst = false
        } else {
            description += ","
        }
        description += "\n"
        description += PrettyPrintedString(object: element, indentation: indentation + 2)
    }
    description += "\n"
    description += indent + "]"
    return description
}

private func PrettyPrintedString(object: Any, indentation: Int = 0, startsWithIdentation: Bool = true) -> String {
    let indent = String(repeating: " ", count: indentation)
    let mirror = Mirror(reflecting: object)
    var description: String = (startsWithIdentation ? indent : "") + String(describing: mirror.subjectType) + "("
    var isFirst = true
    for (label, value) in mirror.children {
        guard let label = label else { continue }
        if isFirst {
            isFirst = false
        } else {
            description += ","
        }
        description += "\n"
        let prettyPrintedValue: String
        if let array = value as? [Any] {
            prettyPrintedValue = PrettyPrintedString(array: array, indentation: indentation + 2)
        } else if let stringConverible = value as? RobinhoodAPIStructStringConvertible {
            prettyPrintedValue = PrettyPrintedString(object: stringConverible, indentation: indentation + 2, startsWithIdentation: false)
        } else {
            prettyPrintedValue = String(describing: value)
        }
        var prettyPrintedLabel: String = label
        if prettyPrintedLabel.hasPrefix("_") {
            // This comes from property wrapper's synthesized property storage
            _ = prettyPrintedLabel.removeFirst()
        }
        description += indent + "  \(prettyPrintedLabel): \(prettyPrintedValue)"
    }
    description += "\n"
    description += indent + ")"
    return description
}

extension RobinhoodAPIStructStringConvertible {
    public var description: String {
        PrettyPrintedString(object: self)
    }
}
