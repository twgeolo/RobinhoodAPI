//
//  RobinhoodClient.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/8/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct Execution: Codable {
        public let id: String
        @SafeValue public var price: Float
        @SafeValue public var quantity: Float
        public let settlementDate: String
        @SafeOptionalValue public var timestamp: Date?

        private enum CodingKeys: String, CodingKey {
            case id
            case price
            case quantity
            case settlementDate = "settlement_date"
            case timestamp
        }
    }

    struct Notional: Codable {
        @SafeValue public var amount: Float
        public let currencyCode: String
        public let currencyID: String

        private enum CodingKeys: String, CodingKey {
            case amount
            case currencyCode = "currency_code"
            case currencyID = "currency_id"
        }
    }

    struct StockOrder: Codable {
        @SafeValue public var account: URL
        @SafeOptionalValue public var averagePrice: Float?
        public let cancel: String?
        @SafeValue public var createdAt: Date
        @SafeValue public var cumulativeQuantity: Float
        public let dollarBasedAmount: String?
        public let dripDividendID: String?
        public let executedNotional: Notional?
        public let executions: [Execution]
        public let extendedHours: Bool
        @SafeValue public var fees: Float
        public let id: String
        @SafeValue public var instrument: URL
        public let investmentScheduleID: String?
        public let ipoAccessLowerCollaredPrice: Float?
        public let ipoAccessLowerPrice: Float?
        public let ipoAccessUpperCollaredPrice: Float?
        public let ipoAccessUpperPrice: Float?
        public let isIPOAccessOrder: Bool
        public let lastTrailPrice: Float?
        @SafeOptionalValue public var lastTrailPriceUpdatedAt: Date?
        @SafeOptionalValue public var lastTransactionAt: Date?
        public let overrideDayTradeChecks: Bool
        public let overrideDTBPChecks: Bool
        public let positions: String?
        @SafeOptionalValue public var price: Float?
        @SafeValue public var quantity: Float
        public let refID: String?
        public let rejectReason: String?
        public let responseCategory: String?
        public let side: String
        public let state: String
        @SafeOptionalValue public var stopPrice: Float?
        public let stopTriggeredAt: String?
        public let timeInForce: String
        public let totalNotional: Notional?
        public let trigger: String
        public let type: String
        @SafeValue public var updatedAt: Date
        @SafeValue public var url: URL

        private enum CodingKeys: String, CodingKey {
            case account
            case averagePrice = "average_price"
            case cancel
            case createdAt = "created_at"
            case cumulativeQuantity = "cumulative_quantity"
            case dollarBasedAmount = "dollar_based_amount"
            case dripDividendID = "drip_dividend_id"
            case executedNotional = "executed_notional"
            case executions
            case extendedHours = "extended_hours"
            case fees
            case id
            case instrument
            case investmentScheduleID = "investment_schedule_id"
            case ipoAccessLowerCollaredPrice = "ipo_access_lower_collared_price"
            case ipoAccessLowerPrice = "ipo_access_lower_price"
            case ipoAccessUpperCollaredPrice = "ipo_access_upper_collared_price"
            case ipoAccessUpperPrice = "ipo_access_upper_price"
            case isIPOAccessOrder = "is_ipo_access_order"
            case lastTrailPrice = "last_trail_price"
            case lastTrailPriceUpdatedAt = "last_trail_price_updated_at"
            case lastTransactionAt = "last_transaction_at"
            case overrideDayTradeChecks = "override_day_trade_checks"
            case overrideDTBPChecks = "override_dtbp_checks"
            case positions
            case price
            case quantity
            case refID = "ref_id"
            case rejectReason = "reject_reason"
            case responseCategory = "response_category"
            case side
            case state
            case stopPrice = "stop_price"
            case stopTriggeredAt = "stop_triggered_at"
            case timeInForce = "time_in_force"
            case totalNotional = "total_notional"
            case trigger
            case type
            case updatedAt = "updated_at"
            case url
        }
    }

    struct Leg: Codable {
        public let executions: [Execution]
        public let id: String
        @SafeValue public var option: URL
        public let positionEffect: String
        public let ratioQuantity: Int
        public let side: String

        private enum CodingKeys: String, CodingKey {
            case executions
            case id
            case option
            case positionEffect = "position_effect"
            case ratioQuantity = "ratio_quantity"
            case side
        }
    }

    struct OptionsOrder: Codable {
        @SafeOptionalValue public var cancelUrl: URL?
        @SafeValue public var canceledQuantity: Float
        public let chainId: String
        public let chainSymbol: String
        public let closingStrategy: String?
        @SafeValue public var createdAt: Date
        public let direction: String
        public let id: String
        public let legs: [Leg]
        public let openingStrategy: String?
        @SafeValue public var pendingQuantity: Float
        @SafeOptionalValue public var premium: Float?
        @SafeOptionalValue public var price: Float?
        @SafeValue public var processedPremium: Float
        @SafeValue public var processedQuantity: Float
        @SafeValue public var quantity: Float
        public let refId: String
        @SafeOptionalValue public var responseCategory: String?
        public let state: String
        @SafeOptionalValue public var stopPrice: Float?
        public let timeInForce: String
        public let trigger: String
        public let type: String
        @SafeValue public var updatedAt: Date

        private enum CodingKeys: String, CodingKey {
            case cancelUrl = "cancel_url"
            case canceledQuantity = "canceled_quantity"
            case chainId = "chain_id"
            case chainSymbol = "chain_symbol"
            case closingStrategy = "closing_strategy"
            case createdAt = "created_at"
            case direction
            case id
            case legs
            case openingStrategy = "opening_strategy"
            case pendingQuantity = "pending_quantity"
            case premium
            case price
            case processedPremium = "processed_premium"
            case processedQuantity = "processed_quantity"
            case quantity
            case refId = "ref_id"
            case responseCategory = "response_category"
            case state
            case stopPrice = "stop_price"
            case timeInForce = "time_in_force"
            case trigger
            case type
            case updatedAt = "updated_at"
        }
    }

    func allStockOrdersPublisher() -> AnyPublisher<PaginatedResponse<StockOrder>, Error> {
        return simpleGETPublisher(url: URL(string: "\(APIHost)orders/")!)
    }

    func openStockOrdersPublisher() -> AnyPublisher<PaginatedResponse<StockOrder>, Error> {
        return allStockOrdersPublisher()
        .flatMap { o -> AnyPublisher<PaginatedResponse<StockOrder>, Error> in
            let results = o.results.filter { $0.cancel == nil }
            let orders = PaginatedResponse<StockOrder>(next: o.next, previous: o.previous, results: results)
            return Just(orders)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func allOptionsOrdersPublisher() -> AnyPublisher<PaginatedResponse<OptionsOrder>, Error> {
        return simpleGETPublisher(url: URL(string: "\(APIHost)options/orders/")!)
    }

    func openOptionsOrdersPublisher() -> AnyPublisher<PaginatedResponse<OptionsOrder>, Error> {
        return allOptionsOrdersPublisher()
        .flatMap { o -> AnyPublisher<PaginatedResponse<OptionsOrder>, Error> in
            let results = o.results.filter { $0.cancelUrl == nil }
            let orders = PaginatedResponse<OptionsOrder>(next: o.next, previous: o.previous, results: results)
            return Just(orders)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

}
