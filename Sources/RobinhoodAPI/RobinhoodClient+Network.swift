//
//  RobinhoodClient.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/8/21.
//

import Foundation
import Combine

extension RobinhoodClient {

    func getRequestPublisher(
        token: String,
        url: URL,
        queryItems: [URLQueryItem]? = nil,
        headerFields: [String: String]? = nil
    ) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        if let queryItems = queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let url = components?.url {
                request = URLRequest(url: url)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let headerFields = headerFields {
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return URLSession.shared.dataTaskPublisher(for: request)
    }

    func postRequestPublisher(
        url: URL,
        body: Any? = nil,
        headerFields: [String: String]? = nil
    ) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headerFields = headerFields {
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        }
        return URLSession.shared.dataTaskPublisher(for: request)
    }

}
