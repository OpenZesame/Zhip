//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Factory
import Foundation
import KeychainSwift
import Zesame

/// The Zilliqa network this build targets. Currently wired to `.mainnet`. When we
/// add staging/testnet builds this will move into a build-configuration driven
/// registration on `Container.shared.zilliqaService`.
let network: Network = .mainnet

extension KeyValueStore where KeyType == PreferencesKey {

    /// The app-wide default `Preferences` store, backed by `UserDefaults.standard`.
    static var `default`: Preferences {
        KeyValueStore(UserDefaults.standard)
    }
}

// MARK: - Services

extension Container {

    /// The reactive façade over `Zesame` blockchain operations. Shared across every
    /// use case so they all talk to the same underlying service instance.
    var zilliqaService: Factory<ZilliqaServiceReactive> {
        self { DefaultZilliqaService(network: network).combine }.singleton
    }

    /// The `UserDefaults`-backed key-value store for non-secret preferences.
    var preferences: Factory<Preferences> {
        self { KeyValueStore(UserDefaults.standard) }.singleton
    }

    /// The Keychain-backed secure store for wallet material and pincode.
    var securePersistence: Factory<SecurePersistence> {
        self { KeyValueStore(KeychainSwift()) }.singleton
    }

    /// Deep-link URL builder for outbound sharing (e.g. receive links).
    var deepLinkGenerator: Factory<DeepLinkGenerator> {
        self { DefaultDeepLinkGenerator() }
    }

    /// Plays bundled sound effects. Tests register a no-op so unit tests never
    /// produce real audio.
    var soundPlayer: Factory<SoundPlayer> {
        self { DefaultSoundPlayer() }.singleton
    }

    /// Abstracts `UIPasteboard.general`. Tests register a `MockPasteboard` so
    /// unit tests never mutate the real simulator pasteboard.
    var pasteboard: Factory<Pasteboard> {
        self { DefaultPasteboard() }.singleton
    }

    /// Abstracts `LAContext` biometric authentication. Tests register a mock
    /// so unit tests never trigger a real Face ID / Touch ID prompt.
    var biometricsAuthenticator: Factory<BiometricsAuthenticator> {
        self { LAContextBiometricsAuthenticator() }.singleton
    }
}

// MARK: - Composite use cases (subsystems that remain monolithic)

extension Container {

    var transactionsUseCase: Factory<TransactionsUseCase> {
        self {
            DefaultTransactionsUseCase(
                zilliqaService: self.zilliqaService(),
                securePersistence: self.securePersistence(),
                preferences: self.preferences()
            )
        }
        .singleton
    }

    var onboardingUseCase: Factory<OnboardingUseCase> {
        self {
            DefaultOnboardingUseCase(
                zilliqaService: self.zilliqaService(),
                preferences: self.preferences(),
                securePersistence: self.securePersistence()
            )
        }
        .singleton
    }

    var pincodeUseCase: Factory<PincodeUseCase> {
        self {
            DefaultPincodeUseCase(
                preferences: self.preferences(),
                securePersistence: self.securePersistence()
            )
        }
        .singleton
    }
}

// MARK: - Narrow wallet use cases

extension Container {

    var createWalletUseCase: Factory<CreateWalletUseCase> {
        self { DefaultCreateWalletUseCase() }
    }

    var restoreWalletUseCase: Factory<RestoreWalletUseCase> {
        self { DefaultRestoreWalletUseCase() }
    }

    var walletStorageUseCase: Factory<WalletStorageUseCase> {
        self { DefaultWalletStorageUseCase() }.singleton
    }

    var verifyEncryptionPasswordUseCase: Factory<VerifyEncryptionPasswordUseCase> {
        self { DefaultVerifyEncryptionPasswordUseCase() }
    }

    var extractKeyPairUseCase: Factory<ExtractKeyPairUseCase> {
        self { DefaultExtractKeyPairUseCase() }
    }
}

// MARK: - Narrow transactions use cases

extension Container {

    var balanceCacheUseCase: Factory<BalanceCacheUseCase> {
        self { self.transactionsUseCase() }
    }

    var gasPriceUseCase: Factory<GasPriceUseCase> {
        self { self.transactionsUseCase() }
    }

    var fetchBalanceUseCase: Factory<FetchBalanceUseCase> {
        self { self.transactionsUseCase() }
    }

    var sendTransactionUseCase: Factory<SendTransactionUseCase> {
        self { self.transactionsUseCase() }
    }

    var transactionReceiptUseCase: Factory<TransactionReceiptUseCase> {
        self { self.transactionsUseCase() }
    }
}
