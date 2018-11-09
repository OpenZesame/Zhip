# Zesame

Zesame is an *unofficial* Swift SDK for Zilliqa. It is written in Swift 4.2. This SDK contains cryptographic methods allowing you to create and restore a wallet, sign and broadcast transactions. The cryptographic methods are implemented in [EllipticCurveKit](https://github.com/Sajjon/EllipticCurveKit). This SDK uses Zilliqas [JSON-RPC API](https://apidocs.zilliqa.com/#introduction)

# API
## Closure or Rx
This SDK contains two implementations for each method, one that uses [Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)(a.k.a. "Callbacks") and one implementation using [RxSwift Observables](https://github.com/ReactiveX/RxSwift).

### Rx
```swift
DefaultZilliqaService.shared.rx.getBalance(for: address).subscribe(
    onNext: { print("Balance: \($0.balance)") },
    onError: { print("Failed to get balance, error: \($0)") }
).disposed(by: bag)
```

### Closure
```swift
DefaultZilliqaService.shared.getBalalance(for: address) {
    switch $0 {
    case .success(let balanceResponse): print("Balance: \(balanceResponse.balance)") 
    case .failure(let error): print("Failed to get balance, error: \(error)")
    }
}
```

## Functions
Have a look at [ZilliqaService.swift](Source/Services/ZilliqaService+Rx/ZilliqaService.swift) for an overview of the functions, here is a snapshot of the current functions of the reactive API (each function having a closure counterpart):
```swift
public protocol ZilliqaServiceReactive {
    func createNewWallet() -> Observable<Wallet>
    func exportKeystore(from wallet: Wallet, encryptWalletBy passphrase: String) -> Observable<Keystore>
    func importWalletFrom(keyStore: Keystore, encryptedBy passphrase: String) -> Observable<Wallet>

    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionIdentifier>
}
```
