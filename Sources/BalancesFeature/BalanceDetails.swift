//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-05-28.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import TCACoordinators
import Zesame
import AmountFormatter
import Styleguide
import Screen

public enum BalanceDetails {}

public extension BalanceDetails {
    struct State: Equatable {
        
        public let tokenBalance: TokenBalance
        
        public init(
            tokenBalance: TokenBalance
        ) {
            self.tokenBalance = tokenBalance
        }

    }
}

public extension BalanceDetails {
    enum Action: Equatable {
        case transfer, receive
    }
}

public extension BalanceDetails {
    struct Environment {
        
    }
}

public extension BalanceDetails {
    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let reducer = Reducer { state, action, environment in
        switch action {
        case .transfer:
            print("Transfer!")
            return .none
        case .receive:
            print("Receive!")
            return .none
        default: break
        }
        return .none
    }
}

public extension BalanceDetails {
    struct Screen: SwiftUI.View {
        public typealias Store = ComposableArchitecture.Store<State, Action>
        let store: Store
        public init(
            store: Store
        ) {
            self.store = store
        }
    }
}

public extension BalanceDetails.Screen {
    var body: some View {
        ForceFullScreen {
            WithViewStore(
                store.scope(
                    state: ViewState.init,
                    action: BalanceDetails.Action.init
                )
            ) { viewStore in
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewStore.tokenSymbol)
                            .font(viewStore.isZil ? .zhip.impression : .zhip.header)
                        Text(viewStore.amount)
                            .font(viewStore.isZil ? .zhip.callToAction : .zhip.body)
                    }
                    
                    HStack {
                        Button("Transfer") {
                            viewStore.send(.transferButtonTapped)
                        }
                        .buttonStyle(.primary)
                        
                        Button("Receive") {
                            viewStore.send(.receiveButtonTapped)
                        }
                        .buttonStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

internal extension BalanceDetails.Screen {
    struct ViewState: Equatable {
        let isZil: Bool
        let amount: String
        let tokenSymbol: String
        init(state: BalanceDetails.State) {
            self.isZil = state.tokenBalance.token == .zilling
            self.tokenSymbol = state.tokenBalance.token.symbol
            self.amount = AmountFormatter().format(
                amount: state.tokenBalance.amount,
                in: .zil,
                formatThousands: true,
                minFractionDigits: nil,
                showUnit: false
            )
        }
    }
    enum ViewAction: Equatable {
        case transferButtonTapped, receiveButtonTapped
    }
}

internal extension BalanceDetails.Action {
    init(action: BalanceDetails.Screen.ViewAction) {
        switch action {
        case .receiveButtonTapped:
            self = .receive
        case .transferButtonTapped:
            self = .transfer
        }
    }
}
