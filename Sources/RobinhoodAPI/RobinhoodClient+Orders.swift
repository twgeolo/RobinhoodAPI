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
        @SafeValue public var timestamp: Date

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

    struct Order: Codable {
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
        public let refID: String
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

    func allStockOrdersPublisher() -> AnyPublisher<PaginatedResponse<Order>, Error> {
        return ordersPublisher(url: URL(string: "\(APIHost)orders/")!)
    }

    func openStockOrdersPublisher() -> AnyPublisher<PaginatedResponse<Order>, Error> {
        return allStockOrdersPublisher()
        .flatMap { o -> AnyPublisher<PaginatedResponse<Order>, Error> in
            let results = o.results.filter { $0.cancel != nil }
            let orders = PaginatedResponse<Order>(next: o.next, previous: o.previous, results: results)
            return Just(orders)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func ordersPublisher(url: URL) -> AnyPublisher<PaginatedResponse<Order>, Error> {
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: url
        )
        .map { $0.data }
        .decode(type: PaginatedResponse<Order>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
