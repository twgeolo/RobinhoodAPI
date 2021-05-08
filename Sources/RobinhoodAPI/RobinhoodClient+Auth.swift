//
//  RobinhoodClient+Auth.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/9/21.
//

import Foundation
import Combine

// MARK: - Auth

public extension RobinhoodClient {

    enum RequestError: Error {
        case unknown(description: String)
    }

    enum AuthResponse {
        case success(response: AuthSuccessResponse)
        case challengeTypeRequired(acceptChallengeTypes: [String: String])
        case challengeIssued(challenge: AuthChallenge)
        case failure(data: Data, response: URLResponse)
    }

    struct AuthSuccessResponse: Codable {
        public let accessToken: String
        public let expiresIn: Int
        public let tokenType: String
        public let scope: String
        public let refreshToken: String
        public let mfaCode: String?
        public let backupCode: String?

        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case tokenType = "token_type"
            case scope
            case refreshToken = "refresh_token"
            case mfaCode = "mfa_code"
            case backupCode = "backup_code"
        }
    }

    struct AuthChallenge: Codable {
        public let id: String
        public let user: String
        public let type: String
        public let alternateType: String?
        public let status: String
        public let remainingRetries: Int
        public let remainingAttempts: Int
        @SafeValue public var expiresAt: Date
        @SafeValue public var updatedAt: Date

        private enum CodingKeys: String, CodingKey {
            case id
            case user
            case type
            case alternateType = "alternate_type"
            case status
            case remainingRetries = "remaining_retries"
            case remainingAttempts = "remaining_attempts"
            case expiresAt = "expires_at"
            case updatedAt = "updated_at"
        }
    }

    /**
     - Account Types:
       - Normal: Simply authenticate without any parameters should work
       - Challenge (2fa): Authentication will return a list of available challenges -> Use one challenge as `challengeType` -> Submit response via `validateChallenge()` -> Once validated, use the id from challenge as `challengeResponseID` and token will be returned
     */
    func authPublisher(
        challengeType: String? = nil,
        challengeResponseID: String? = nil
    ) -> AnyPublisher<AuthResponse, Error> {
        var headerFields: [String: String]?
        if let challengeResponseID = challengeResponseID {
            headerFields = ["X-ROBINHOOD-CHALLENGE-RESPONSE-ID": challengeResponseID]
        }
        var body: [String: Any] = [
            "grant_type": "password",
            "scope": "internal",
            "client_id": "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS",
            "expires_in": 86400,
            "password": password,
            "username": username,
            "device_token": "ea9fa5c6-01e0-46c9-8430-5b422c99bd16"
        ]
        if let challengeType = challengeType {
            body["challenge_type"] = challengeType
        }
        return Self.postRequestPublisher(
            url: URL(string: "\(APIHost)oauth2/token/")!,
            body: body,
            headerFields: headerFields
        )
        .tryMap { output in
            guard let response = try? JSONDecoder().decode(AuthSuccessResponse.self, from: output.data) else {
                if let decoded = try? JSONSerialization.jsonObject(with: output.data, options: .allowFragments) as? [String: Any],
                   let detail = decoded["detail"] as? String {
                    if detail.contains("challenge type required"),
                       let challengeTypes = decoded["accept_challenge_types"] as? [String: String] {
                        return .challengeTypeRequired(acceptChallengeTypes: challengeTypes)
                    }
                    if detail.contains("challenge issued"),
                       let challengeData = decoded["challenge"] as? [String: Any],
                       let encodedData = try? JSONSerialization.data(withJSONObject: challengeData),
                       let challenge = try? JSONDecoder().decode(AuthChallenge.self, from: encodedData) {
                        return .challengeIssued(challenge: challenge)
                    }
                }
                return .failure(data: output.data, response: output.response)
            }
            self.authMetadata = AuthMetadata(
                accessToken: response.accessToken,
                expiresIn: Date().addingTimeInterval(TimeInterval(response.expiresIn))
            )
            return .success(response: response)
        }
        .eraseToAnyPublisher()
    }

    internal func tokenPublisher() -> AnyPublisher<String, Error> {
        guard let authMetadata = authMetadata else {
            return Fail(error: RequestError.unknown(description: "User did not authenticate"))
                .eraseToAnyPublisher()
        }
        if authMetadata.expiresIn < Date().addingTimeInterval(-10) {
            return authPublisher()
                .tryMap { response in
                    if case let .success(successResponse) = response {
                        return successResponse.accessToken
                    } else {
                        throw RequestError.unknown(description: "Auth failed")
                    }
                }
                .eraseToAnyPublisher()
        } else {
            return Just(authMetadata.accessToken)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    func validateChallengePublisher(
        challenge: AuthChallenge,
        response: String
    ) -> AnyPublisher<AuthChallenge, Error> {
        return Self.postRequestPublisher(
            url: URL(string: "\(APIHost)challenge/\(challenge.id)/respond/")!,
            body: ["response": response]
        )
        .map { $0.data }
        .decode(type: AuthChallenge.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
