//
//  RobinhoodClient+Options.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/10/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct Options: Codable {
        public let canOpenPosition: Bool
        public let cashComponent: String?
        public let expirationDates: [String]
        public let id: String
        public let minTicks: Options.MinTicks
        public let symbol: String
        @SafeValue public var tradeValueMultiplier: Float
        public let underlyingInstruments: [Options.Instrument]

        private enum CodingKeys: String, CodingKey {
            case canOpenPosition = "can_open_position"
            case cashComponent = "cash_component"
            case expirationDates = "expiration_dates"
            case id
            case minTicks = "min_ticks"
            case symbol
            case tradeValueMultiplier = "trade_value_multiplier"
            case underlyingInstruments = "underlying_instruments"
        }

        public struct Instrument: Codable {
            public let id: String
            @SafeValue public var instrument: URL
            public let quantity: Int

            private enum CodingKeys: String, CodingKey {
                case id
                case instrument
                case quantity
            }
        }

        public struct MinTicks: Codable, RobinhoodAPIStructStringConvertible {
            @SafeValue public var aboveTick: Float
            @SafeValue public var belowTick: Float
            @SafeValue public var cutoffPrice: Float

            private enum CodingKeys: String, CodingKey {
                case aboveTick = "above_tick"
                case belowTick = "below_tick"
                case cutoffPrice = "cutoff_price"
            }
        }
    }

    func optionChainsPublisher(symbol: String) -> AnyPublisher<Options, Error> {
        stockInstrumentPublisher(symbol: symbol)
            .flatMap { [weak self] instrument -> AnyPublisher<Options, Error> in
                guard let strongSelf = self else {
                    return Fail(error: RequestError.unknown(description: "RobinhoodClient deallocated"))
                        .eraseToAnyPublisher()
                }
                let chainId = instrument.results.first!.tradableChainId!
                return strongSelf.simpleGETPublisher(url: URL(string: "https://api.robinhood.com/options/chains/\(chainId)/")!)
            }
            .eraseToAnyPublisher()
    }

}
