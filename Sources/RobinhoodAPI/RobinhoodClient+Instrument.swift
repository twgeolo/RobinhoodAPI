//
//  RobinhoodClient+Instrument.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/9/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct StockInstrument: Codable {
        @SafeOptionalValue public var bloombergUnique: String?
        public let country: String
        @SafeValue public var dayTradeRatio: Float
        @SafeValue public var defaultCollarFraction: Float
        public let fractionalTradability: String
        @SafeValue public var fundamentals: URL
        public let id: String
        public let ipoAccessCOBDeadline: String?
        public let ipoAccessStatus: String?
        @SafeOptionalValue public var ipoAllocatedPrice: Float?
        public let ipoCustomersReceived: String?
        public let ipoCustomersRequested: String?
        public let ipoDate: String?
        public let ipoS1Url: String?
        public let isSpac: Bool
        public let isTest: Bool
        public let listDate: String
        @SafeValue public var maintenanceRatio: Float
        @SafeValue public var marginInitialRatio: Float
        @SafeValue public var market: URL
        public let minTickSize: String?
        public let name: String
        @SafeValue public var quote: URL
        public let rhsTradability: String
        public let simpleName: String
        @SafeValue public var splits: URL
        public let state: String
        public let symbol: String
        public let tradability: String
        public let tradableChainId: String?
        public let tradeable: Bool
        public let type: String
        @SafeValue public var url: URL

        private enum CodingKeys: String, CodingKey {
            case bloombergUnique = "bloomberg_unique"
            case country
            case dayTradeRatio = "day_trade_ratio"
            case defaultCollarFraction = "default_collar_fraction"
            case fractionalTradability = "fractional_tradability"
            case fundamentals
            case id
            case ipoAccessCOBDeadline = "ipo_access_cob_deadline"
            case ipoAccessStatus = "ipo_access_status"
            case ipoAllocatedPrice = "ipo_allocated_price"
            case ipoCustomersReceived = "ipo_customers_received"
            case ipoCustomersRequested = "ipo_customers_requested"
            case ipoDate = "ipo_date"
            case ipoS1Url = "ipo_s1_url"
            case isSpac = "is_spac"
            case isTest = "is_test"
            case listDate = "list_date"
            case maintenanceRatio = "maintenance_ratio"
            case marginInitialRatio = "margin_initial_ratio"
            case market
            case minTickSize = "min_tick_size"
            case name
            case quote
            case rhsTradability = "rhs_tradability"
            case simpleName = "simple_name"
            case splits
            case state
            case symbol
            case tradability
            case tradableChainId = "tradable_chain_id"
            case tradeable
            case type
            case url
        }
    }

    func stockInstrumentPublisher(symbol: String) -> AnyPublisher<PaginatedResponse<StockInstrument>, Error> {
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: URL(string: "https://api.robinhood.com/instruments/")!,
            queryItems: [URLQueryItem(name: "symbol", value: symbol)]
        )
        .map { $0.data }
        .decode(type: PaginatedResponse<StockInstrument>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    func stockInstrumentPublisher(url: URL) -> AnyPublisher<StockInstrument, Error> {
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: url
        )
        .map { $0.data }
        .decode(type: StockInstrument.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    struct OptionsInstrument: Codable, RobinhoodAPIStructStringConvertible {
        public let chainId: String
        public let chainSymbol: String
        @SafeValue public var createdAt: Date
        public let expirationDate: String
        public let id: String
        public let issueDate: String
        public let minTicks: OptionsChain.MinTicks
        public let rhsTradability: String
        @SafeOptionalValue public var selloutDatetime: Date?
        public let state: String
        @SafeValue public var strikePrice: Float
        public let tradability: String
        public let type: String
        @SafeValue public var updatedAt: Date
        @SafeValue public var url: URL

        private enum CodingKeys: String, CodingKey {
            case chainId = "chain_id"
            case chainSymbol = "chain_symbol"
            case createdAt = "created_at"
            case expirationDate = "expiration_date"
            case id
            case issueDate = "issue_date"
            case minTicks = "min_ticks"
            case rhsTradability = "rhs_tradability"
            case selloutDatetime = "sellout_datetime"
            case state
            case strikePrice = "strike_price"
            case tradability
            case type
            case updatedAt = "updated_at"
            case url
        }
    }

    enum OptionsType: String {
        case both
        case call
        case put
    }

    func optionsInstrumentPublisher(chainId: String, expirationDate: String, type: OptionsType = .both) -> AnyPublisher<PaginatedResponse<OptionsInstrument>, Error> {
        var queryItems = [
            URLQueryItem(name: "chain_id", value: chainId),
            URLQueryItem(name: "expiration_dates", value: expirationDate),
            URLQueryItem(name: "state", value: "active"),
            URLQueryItem(name: "tradability", value: "tradable")
        ]
        if type != .both {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: URL(string: "https://api.robinhood.com/options/instruments/")!,
            queryItems: queryItems
        )
        .map { $0.data }
        .decode(type: PaginatedResponse<OptionsInstrument>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
