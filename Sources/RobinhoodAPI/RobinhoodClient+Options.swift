//
//  RobinhoodClient+Options.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/10/21.
//

import Foundation
import Combine

public extension RobinhoodClient {

    struct OptionsChain: Codable {
        public let canOpenPosition: Bool
        public let cashComponent: String?
        public let expirationDates: [String]
        public let id: String
        public let minTicks: OptionsChain.MinTicks
        public let symbol: String
        @SafeValue public var tradeValueMultiplier: Float
        public let underlyingInstruments: [OptionsChain.Instrument]

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

    func optionChainsPublisher(symbol: String) -> AnyPublisher<OptionsChain, Error> {
        return stockInstrumentPublisher(symbol: symbol)
            .mapError { $0 as Error }
            .map { $0.results.first?.tradableChainId }
            .flatMap { chainId in
                self.getRequestPublisher(
                    token: self.lastAuthSuccessResponse!.accessToken, // FIXME: Auth
                    url: URL(string: "https://api.robinhood.com/options/chains/\(chainId!)/")!
                )
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: OptionsChain.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
