//
//  RobinhoodAPI+Data.swift
//  RobinhoodAPI
//
//  Created by George Lo on 5/6/21.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed),
              let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
