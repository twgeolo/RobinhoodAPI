//
//  RobinhoodClient+Account.swift
//  RobinhoodAPI
//
//  Created by George Lo on 3/8/21.
//

import Foundation
import Combine

// MARK: - Account

public extension RobinhoodClient {

    struct InstantEligibility: Codable {
        @SafeValue public var additionalDepositNeeded: Float
        public let complianceUserMajorOakEmail: String
        @SafeValue public var createdAt: Date
        public let createdBy: String
        public let reason: String
        public let reinstatementDate: String?
        public let reversal: String?
        public let state: String
        @SafeValue public var updatedAt: Date

        private enum CodingKeys: String, CodingKey {
            case additionalDepositNeeded = "additional_deposit_needed"
            case complianceUserMajorOakEmail = "compliance_user_major_oak_email"
            case createdAt = "created_at"
            case createdBy = "created_by"
            case reason
            case reinstatementDate = "reinstatement_date"
            case reversal
            case state
            case updatedAt = "updated_at"
        }
    }

    struct MarginBalances: Codable {
        @SafeValue public var cash: Float
        @SafeValue public var cashAvailableForWithdrawal: Float
        @SafeValue public var cashHeldForDividends: Float
        @SafeValue public var cashHeldForNummusRestrictions: Float
        @SafeValue public var cashHeldForOptionsCollateral: Float
        @SafeValue public var cashHeldForOrders: Float
        @SafeValue public var cashHeldForRestrictions: Float
        @SafeValue public var cashPendingFromOptionsEvents: Float
        @SafeValue public var createdAt: Date
        @SafeValue public var cryptoBuyingPower: Float
        @SafeValue public var dayTradeBuyingPower: Float
        @SafeValue public var dayTradeBuyingPowerHeldForOrders: Float
        @SafeValue public var dayTradeRatio: Float
        public let dayTradesProtection: Bool
        @SafeValue public var eligibleDepositAsInstant: Float
        @SafeValue public var fundingHoldBalance: Float
        @SafeValue public var goldEquityRequirement: Float
        @SafeValue public var instantAllocated: Float
        @SafeValue public var instantUsed: Float
        public let marginLimit: String?
        public let marginWithdrawalLimit: String?
        public let markedPatternDayTraderDate: String
        @SafeValue public var netMovingCash: Float
        @SafeValue public var outstandingInterest: Float
        @SafeValue public var overnightBuyingPower: Float
        @SafeValue public var overnightBuyingPowerHeldForOrders: Float
        @SafeValue public var overnightRatio: Float
        @SafeValue public var pendingDebitCardDebits: Float
        @SafeValue public var pendingDeposit: Float
        @SafeValue public var portfolioCash: Float
        @SafeValue public var settledAmountBorrowed: Float
        @SafeValue public var sma: Int
        @SafeValue public var startOfDayDTBP: Float
        @SafeValue public var startOfDayOvernightBuyingPower: Float
        @SafeValue public var unallocatedMarginCash: Float
        @SafeValue public var unclearedDeposits: Float
        @SafeValue public var unclearedNummusDeposits: Float
        @SafeValue public var unsettledDebit: Float
        @SafeValue public var unsettledFunds: Float
        @SafeValue public var updatedAt: Date

        private enum CodingKeys: String, CodingKey {
            case cash
            case cashAvailableForWithdrawal = "cash_available_for_withdrawal"
            case cashHeldForDividends = "cash_held_for_dividends"
            case cashHeldForNummusRestrictions = "cash_held_for_nummus_restrictions"
            case cashHeldForOptionsCollateral = "cash_held_for_options_collateral"
            case cashHeldForOrders = "cash_held_for_orders"
            case cashHeldForRestrictions = "cash_held_for_restrictions"
            case cashPendingFromOptionsEvents = "cash_pending_from_options_events"
            case createdAt = "created_at"
            case cryptoBuyingPower = "crypto_buying_power"
            case dayTradeBuyingPower = "day_trade_buying_power"
            case dayTradeBuyingPowerHeldForOrders = "day_trade_buying_power_held_for_orders"
            case dayTradeRatio = "day_trade_ratio"
            case dayTradesProtection = "day_trades_protection"
            case eligibleDepositAsInstant = "eligible_deposit_as_instant"
            case fundingHoldBalance = "funding_hold_balance"
            case goldEquityRequirement = "gold_equity_requirement"
            case instantAllocated = "instant_allocated"
            case instantUsed = "instant_used"
            case marginLimit = "margin_limit"
            case marginWithdrawalLimit = "margin_withdrawal_limit"
            case markedPatternDayTraderDate = "marked_pattern_day_trader_date"
            case netMovingCash = "net_moving_cash"
            case outstandingInterest = "outstanding_interest"
            case overnightBuyingPower = "overnight_buying_power"
            case overnightBuyingPowerHeldForOrders = "overnight_buying_power_held_for_orders"
            case overnightRatio = "overnight_ratio"
            case pendingDebitCardDebits = "pending_debit_card_debits"
            case pendingDeposit = "pending_deposit"
            case portfolioCash = "portfolio_cash"
            case settledAmountBorrowed = "settled_amount_borrowed"
            case sma
            case startOfDayDTBP = "start_of_day_dtbp"
            case startOfDayOvernightBuyingPower = "start_of_day_overnight_buying_power"
            case unallocatedMarginCash = "unallocated_margin_cash"
            case unclearedDeposits = "uncleared_deposits"
            case unclearedNummusDeposits = "uncleared_nummus_deposits"
            case unsettledDebit = "unsettled_debit"
            case unsettledFunds = "unsettled_funds"
            case updatedAt = "updated_at"
        }
    }

    struct Account: Codable {
        public let accountNumber: String
        public let activeSubscriptionID: String
        @SafeValue public var amountEligibleForDepositCancellation: Float
        @SafeValue public var buyingPower: Float
        @SafeOptionalValue public var canDowngradeToCash: URL?
        @SafeValue public var cash: Float
        @SafeValue public var cashAvailableForWithdrawal: Float
        @SafeOptionalValue public var cashBalances: Float?
        @SafeValue public var cashHeldForOptionsCollateral: Float
        @SafeValue public var cashHeldForOrders: Float
        public let cashManagementEnabled: Bool
        @SafeValue public var createdAt: Date
        @SafeValue public var cryptoBuyingPower: Float
        public let deactivated: Bool
        public let depositHalted: Bool
        public let dripEnabled: Bool
        @SafeOptionalValue public var eligibleForCashManagement: URL?
        public let eligibleForDrip: Bool
        public let eligibleForFractionals: Bool
        public let equityTradingLock: String
        public let fractionalPositionClosingOnly: Bool
        public let instantEligibility: InstantEligibility
        public let isPinnacleAccount: Bool
        public let locked: Bool
        public let marginBalances: MarginBalances
        @SafeValue public var maxACHEarlyAccessAmount: Float
        public let onlyPositionClosingTrades: Bool
        public let optionLevel: String
        public let optionTradingLock: String
        public let optionTradingOnExpirationEnabled: Bool
        public let permanentlyDeactivated: Bool
        @SafeValue public var portfolioCash: Float
        public let receivedACHDebitLocked: Bool
        @SafeValue public var rhsAccountNumber: Int
        public let rhsStockLoanConsentStatus: String
        @SafeValue public var sma: Int
        @SafeValue public var smaHeldForOrders: Int
        public let state: String
        public let sweepEnabled: Bool
        public let type: String
        @SafeValue public var unclearedDeposits: Float
        @SafeValue public var unsettledDebit: Float
        @SafeValue public var unsettledFunds: Float
        @SafeValue public var updatedAt: Date
        @SafeValue public var url: URL
        public let user: String
        public let userID: String
        public let withdrawalHalted: Bool

        private enum CodingKeys: String, CodingKey {
            case accountNumber = "account_number"
            case activeSubscriptionID = "active_subscription_id"
            case amountEligibleForDepositCancellation = "amount_eligible_for_deposit_cancellation"
            case buyingPower = "buying_power"
            case canDowngradeToCash = "can_downgrade_to_cash"
            case cash
            case cashAvailableForWithdrawal = "cash_available_for_withdrawal"
            case cashBalances = "cash_balances"
            case cashHeldForOptionsCollateral = "cash_held_for_options_collateral"
            case cashHeldForOrders = "cash_held_for_orders"
            case cashManagementEnabled = "cash_management_enabled"
            case createdAt = "created_at"
            case cryptoBuyingPower = "crypto_buying_power"
            case deactivated
            case depositHalted = "deposit_halted"
            case dripEnabled = "drip_enabled"
            case eligibleForCashManagement = "eligible_for_cash_management"
            case eligibleForDrip = "eligible_for_drip"
            case eligibleForFractionals = "eligible_for_fractionals"
            case equityTradingLock = "equity_trading_lock"
            case fractionalPositionClosingOnly = "fractional_position_closing_only"
            case instantEligibility = "instant_eligibility"
            case isPinnacleAccount = "is_pinnacle_account"
            case locked
            case marginBalances = "margin_balances"
            case maxACHEarlyAccessAmount = "max_ach_early_access_amount"
            case onlyPositionClosingTrades = "only_position_closing_trades"
            case optionLevel = "option_level"
            case optionTradingLock = "option_trading_lock"
            case optionTradingOnExpirationEnabled = "option_trading_on_expiration_enabled"
            case permanentlyDeactivated = "permanently_deactivated"
            case portfolioCash = "portfolio_cash"
            case receivedACHDebitLocked = "received_ach_debit_locked"
            case rhsAccountNumber = "rhs_account_number"
            case rhsStockLoanConsentStatus = "rhs_stock_loan_consent_status"
            case sma
            case smaHeldForOrders = "sma_held_for_orders"
            case state
            case sweepEnabled = "sweep_enabled"
            case type
            case unclearedDeposits = "uncleared_deposits"
            case unsettledDebit = "unsettled_debit"
            case unsettledFunds = "unsettled_funds"
            case updatedAt = "updated_at"
            case url
            case user
            case userID = "user_id"
            case withdrawalHalted = "withdrawal_halted"
        }
    }

    func accountsPublisher() -> AnyPublisher<PaginatedResponse<Account>, Error> {
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: URL(string: "\(APIHost)accounts/")!
        )
        .map { $0.data }
        .decode(type: PaginatedResponse<Account>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}

// MARK: - Positions

public extension RobinhoodClient {

    struct Position: Codable {
        @SafeValue public var account: URL
        public let accountNumber: String
        @SafeValue public var averageBuyPrice: Float
        @SafeValue public var createdAt: Date
        @SafeValue public var instrument: URL
        @SafeValue public var intradayAverageBuyPrice: Float
        @SafeValue public var intradayQuantity: Float
        @SafeValue public var pendingAverageBuyPrice: Float
        @SafeValue public var quantity: Float
        @SafeValue public var sharesAvailableForClosingShortPosition: Float
        @SafeValue public var sharesAvailableForExercise: Float
        @SafeValue public var sharesHeldForBuys: Float
        @SafeValue public var sharesHeldForOptionsCollateral: Float
        @SafeValue public var sharesHeldForOptionsEvents: Float
        @SafeValue public var sharesHeldForSells: Float
        @SafeValue public var sharesHeldForStockGrants: Float
        @SafeValue public var sharesPendingFromOptionsEvents: Float
        @SafeValue public var updatedAt: Date
        @SafeValue public var url: URL

        private enum CodingKeys: String, CodingKey {
            case account
            case accountNumber = "account_number"
            case averageBuyPrice = "average_buy_price"
            case createdAt = "created_at"
            case instrument
            case intradayAverageBuyPrice = "intraday_average_buy_price"
            case intradayQuantity = "intraday_quantity"
            case pendingAverageBuyPrice = "pending_average_buy_price"
            case quantity
            case sharesAvailableForClosingShortPosition = "shares_available_for_closing_short_position"
            case sharesAvailableForExercise = "shares_available_for_exercise"
            case sharesHeldForBuys = "shares_held_for_buys"
            case sharesHeldForOptionsCollateral = "shares_held_for_options_collateral"
            case sharesHeldForOptionsEvents = "shares_held_for_options_events"
            case sharesHeldForSells = "shares_held_for_sells"
            case sharesHeldForStockGrants = "shares_held_for_stock_grants"
            case sharesPendingFromOptionsEvents = "shares_pending_from_options_events"
            case updatedAt = "updated_at"
            case url
        }
    }

    func allPositionsPublisher() -> AnyPublisher<PaginatedResponse<Position>, Error> {
        return _positionsPublisher(onlyOpen: false)
    }

    func openPositionsPublisher() -> AnyPublisher<PaginatedResponse<Position>, Error> {
        return _positionsPublisher(onlyOpen: true)
    }

    private func _positionsPublisher(onlyOpen: Bool) -> AnyPublisher<PaginatedResponse<Position>, Error> {
        return getRequestPublisher(
            token: lastAuthSuccessResponse!.accessToken, // FIXME: Auth
            url: URL(string: "\(APIHost)positions/")!,
            queryItems: onlyOpen ? [URLQueryItem(name: "nonzero", value: "true")] : nil
        )
        .map { $0.data }
        .decode(type: PaginatedResponse<Position>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
