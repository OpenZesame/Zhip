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

// MARK: - Marker protocols

/// Marker protocol for any type that owns a `SecurePersistence` dependency.
///
/// Adopters get free, default storage-related implementations via the extensions on
/// `WalletStorageUseCase` below.
protocol SecurePersisting: AnyObject {

    /// The underlying secure keystore (typically Keychain-backed) used to read and
    /// write sensitive wallet material.
    var securePersistence: SecurePersistence { get }
}

// MARK: - Narrow use cases (split from the old monolithic `WalletUseCase`)

/// Creates a brand-new wallet from a user-chosen encryption password.
protocol CreateWalletUseCase: AnyObject {

    /// Generates a fresh wallet, encrypts it with `encryptionPassword`, and emits
    /// the resulting `Wallet` once on success.
    func createNewWallet(encryptionPassword: String) -> AnyPublisher<Wallet, Swift.Error>
}

/// Restores an existing wallet from user-provided keystore or private-key material.
protocol RestoreWalletUseCase: AnyObject {

    /// Restores a wallet using the supplied `KeyRestoration` (either `.keystore` or
    /// `.privateKey`) and emits the resulting `Wallet` once on success.
    func restoreWallet(from restoration: KeyRestoration) -> AnyPublisher<Wallet, Swift.Error>
}

/// Reads and writes the user's wallet to secure persistent storage.
///
/// All methods have default implementations in terms of `SecurePersisting`, so any
/// concrete type owning a `SecurePersistence` gets these for free.
protocol WalletStorageUseCase: AnyObject {

    /// Persists `wallet` to secure storage (replacing any previously saved wallet).
    func save(wallet: Wallet)

    /// Removes the currently-persisted wallet, if any.
    func deleteWallet()

    /// Loads the currently-persisted wallet synchronously, or `nil` if none exists.
    func loadWallet() -> Wallet?

    /// `true` if there is a wallet currently persisted in secure storage.
    var hasConfiguredWallet: Bool { get }
}

/// Verifies whether a user-provided password successfully decrypts a keystore.
protocol VerifyEncryptionPasswordUseCase: AnyObject {

    /// Checks if the passed `password` was used to encrypt `keystore`. The resulting
    /// publisher emits `true`/`false` on the main queue.
    func verify(password: String, forKeystore keystore: Keystore) -> AnyPublisher<Bool, Swift.Error>
}

/// Extracts the raw `KeyPair` from a keystore (public + private key) when supplied
/// with the correct encryption password.
protocol ExtractKeyPairUseCase: AnyObject {

    /// Decrypts `keystore` with `password` and emits the underlying `KeyPair`.
    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> AnyPublisher<KeyPair, Swift.Error>
}

// MARK: - Composite façade (backward-compatibility)

/// Composite protocol retained for backwards compatibility with existing call sites.
///
/// Prefer depending on the narrower protocols above (`CreateWalletUseCase`,
/// `RestoreWalletUseCase`, `WalletStorageUseCase`, `VerifyEncryptionPasswordUseCase`,
/// `ExtractKeyPairUseCase`) in new code.
protocol WalletUseCase: CreateWalletUseCase,
                       RestoreWalletUseCase,
                       WalletStorageUseCase,
                       VerifyEncryptionPasswordUseCase,
                       ExtractKeyPairUseCase {}

// MARK: - Convenience extensions

extension VerifyEncryptionPasswordUseCase {

    /// Convenience overload that verifies a password against the keystore embedded
    /// inside a `Wallet`.
    func verify(password: String, forWallet wallet: Wallet) -> AnyPublisher<Bool, Swift.Error> {
        verify(password: password, forKeystore: wallet.keystore)
    }
}

extension ExtractKeyPairUseCase {

    /// Convenience overload that extracts a key pair from the keystore inside a `Wallet`.
    func extractKeyPairFrom(wallet: Wallet, encryptedBy password: String) -> AnyPublisher<KeyPair, Swift.Error> {
        extractKeyPairFrom(keystore: wallet.keystore, encryptedBy: password)
    }
}

// MARK: - Default `WalletStorageUseCase` implementation for `SecurePersisting` types

extension WalletStorageUseCase where Self: SecurePersisting {

    func deleteWallet() {
        securePersistence.deleteWallet()
    }

    func loadWallet() -> Wallet? {
        securePersistence.wallet
    }

    func save(wallet: Wallet) {
        securePersistence.save(wallet: wallet)
    }

    var hasConfiguredWallet: Bool {
        securePersistence.hasConfiguredWallet
    }
}

extension WalletStorageUseCase {

    /// Emits the currently-persisted wallet (or `nil`) as a one-shot publisher.
    var wallet: AnyPublisher<Wallet?, Never> {
        Just(loadWallet()).eraseToAnyPublisher()
    }
}
