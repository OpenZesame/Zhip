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

import Combine
import Foundation
import Zesame

/// Seedable mock for `ZilliqaServiceReactive` used by `Default*UseCase` tests.
/// Each method returns the corresponding `*Result` property once, wrapped in a
/// publisher. Call counters are exposed for assertions.
final class MockZilliqaServiceReactive: ZilliqaServiceReactive {

    var createNewWalletResult: Result<Zesame.Wallet, Zesame.Error>?
    var restoreWalletResult: Result<Zesame.Wallet, Zesame.Error>?
    var verifyEncryptionPasswordResult: Result<Bool, Zesame.Error>?
    var extractKeyPairResult: Result<KeyPair, Zesame.Error>?
    var minimumGasPriceResult: Result<MinimumGasPriceResponse, Zesame.Error>?
    var balanceResult: Result<BalanceResponse, Zesame.Error>?

    private(set) var createNewWalletCallCount = 0
    private(set) var restoreWalletCallCount = 0
    private(set) var verifyEncryptionPasswordCallCount = 0
    private(set) var extractKeyPairCallCount = 0

    private(set) var lastCreateWalletPassword: String?
    private(set) var lastCreateWalletKDF: KDF?
    private(set) var lastRestoration: KeyRestoration?
    private(set) var lastVerifyPassword: String?

    func getNetworkFromAPI() -> AnyPublisher<NetworkResponse, Zesame.Error> {
        Empty<NetworkResponse, Zesame.Error>().eraseToAnyPublisher()
    }

    func getMinimumGasPrice(alsoUpdateLocallyCachedMinimum: Bool)
        -> AnyPublisher<MinimumGasPriceResponse, Zesame.Error>
    {
        Self.publisher(for: minimumGasPriceResult)
    }

    func verifyThat(encryptionPassword: String, canDecryptKeystore: Keystore)
        -> AnyPublisher<Bool, Zesame.Error>
    {
        verifyEncryptionPasswordCallCount += 1
        lastVerifyPassword = encryptionPassword
        return Self.publisher(for: verifyEncryptionPasswordResult)
    }

    func createNewWallet(encryptionPassword: String, kdf: KDF)
        -> AnyPublisher<Zesame.Wallet, Zesame.Error>
    {
        createNewWalletCallCount += 1
        lastCreateWalletPassword = encryptionPassword
        lastCreateWalletKDF = kdf
        return Self.publisher(for: createNewWalletResult)
    }

    func restoreWallet(from restoration: KeyRestoration)
        -> AnyPublisher<Zesame.Wallet, Zesame.Error>
    {
        restoreWalletCallCount += 1
        lastRestoration = restoration
        return Self.publisher(for: restoreWalletResult)
    }

    func exportKeystore(privateKey: PrivateKey, encryptWalletBy password: String)
        -> AnyPublisher<Keystore, Zesame.Error>
    {
        Empty<Keystore, Zesame.Error>().eraseToAnyPublisher()
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String)
        -> AnyPublisher<KeyPair, Zesame.Error>
    {
        extractKeyPairCallCount += 1
        return Self.publisher(for: extractKeyPairResult)
    }

    func getBalance(for address: LegacyAddress) -> AnyPublisher<BalanceResponse, Zesame.Error> {
        Self.publisher(for: balanceResult)
    }

    func sendTransaction(for payment: Payment, keystore: Keystore, password: String, network: Network)
        -> AnyPublisher<TransactionResponse, Zesame.Error>
    {
        Empty<TransactionResponse, Zesame.Error>().eraseToAnyPublisher()
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, network: Network)
        -> AnyPublisher<TransactionResponse, Zesame.Error>
    {
        Empty<TransactionResponse, Zesame.Error>().eraseToAnyPublisher()
    }

    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling)
        -> AnyPublisher<TransactionReceipt, Zesame.Error>
    {
        Empty<TransactionReceipt, Zesame.Error>().eraseToAnyPublisher()
    }

    private static func publisher<T>(for result: Result<T, Zesame.Error>?) -> AnyPublisher<T, Zesame.Error> {
        guard let result else { return Empty<T, Zesame.Error>().eraseToAnyPublisher() }
        switch result {
        case .success(let value):
            return Just(value).setFailureType(to: Zesame.Error.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail<T, Zesame.Error>(error: error).eraseToAnyPublisher()
        }
    }
}
