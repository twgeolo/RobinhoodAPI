//
//  RobinhoodClient+Marketdata.swift
//  RobinhoodAPI
//
//  Created by George Lo on 5/7/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct OptionsChain: Codable, RobinhoodAPIStructStringConvertible {
        @SafeValue public var adjustedMarkPrice: Float
        @SafeValue public var askPrice: Float
        public let askSize: Int
        @SafeValue public var bidPrice: Float
        public let bidSize: Int
        @SafeValue public var breakEvenPrice: Float
        @SafeOptionalValue public var chanceOfProfitLong: Float?
        @SafeOptionalValue public var chanceOfProfitShort: Float?
        @SafeOptionalValue public var delta: Float?
        @SafeOptionalValue public var gamma: Float?
        @SafeValue public var highFillRateBuyPrice: Float
        @SafeValue public var highFillRateSellPrice: Float
        @SafeOptionalValue public var highPrice: Float?
        @SafeOptionalValue public var impliedVolatility: Float?
        @SafeValue public var instrument: URL
        public let instrumentId: String
        @SafeOptionalValue public var lastTradePrice: Float?
        public let lastTradeSize: Int?
        @SafeValue public var lowFillRateBuyPrice: Float
        @SafeValue public var lowFillRateSellPrice: Float
        @SafeOptionalValue public var lowPrice: Float?
        @SafeValue public var markPrice: Float
        public let occSymbol: String
        public let openInterest: Int
        public let previousCloseDate: String
        @SafeValue public var previousClosePrice: Float
        @SafeOptionalValue public var rho: Float?
        public let symbol: String
        @SafeOptionalValue public var theta: Float?
        @SafeOptionalValue public var vega: Float?
        public let volume: Int

        private enum CodingKeys: String, CodingKey {
            case adjustedMarkPrice = "adjusted_mark_price"
            case askPrice = "ask_price"
            case askSize = "ask_size"
            case bidPrice = "bid_price"
            case bidSize = "bid_size"
            case breakEvenPrice = "break_even_price"
            case chanceOfProfitLong = "chance_of_profit_long"
            case chanceOfProfitShort = "chance_of_profit_short"
            case delta
            case gamma
            case highFillRateBuyPrice = "high_fill_rate_buy_price"
            case highFillRateSellPrice = "high_fill_rate_sell_price"
            case highPrice = "high_price"
            case impliedVolatility = "implied_volatility"
            case instrument
            case instrumentId = "instrument_id"
            case lastTradePrice = "last_trade_price"
            case lastTradeSize = "last_trade_size"
            case lowFillRateBuyPrice = "low_fill_rate_buy_price"
            case lowFillRateSellPrice = "low_fill_rate_sell_price"
            case lowPrice = "low_price"
            case markPrice = "mark_price"
            case occSymbol = "occ_symbol"
            case openInterest = "open_interest"
            case previousCloseDate = "previous_close_date"
            case previousClosePrice = "previous_close_price"
            case rho
            case symbol
            case theta
            case vega
            case volume
        }
    }

    func optionsMarketdataPublisher(id: String) -> AnyPublisher<OptionsChain, Error> {
        return simpleGETPublisher(url: URL(string: "https://api.robinhood.com/marketdata/options/\(id)/")!)
    }

}
