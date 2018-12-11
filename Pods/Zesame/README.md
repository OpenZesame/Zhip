# Zesame

Zesame is an *unofficial* Swift SDK for Zilliqa. It is written in Swift 4.2. This SDK contains cryptographic methods allowing you to create and restore a wallet, sign and broadcast transactions. The cryptographic methods are implemented in [EllipticCurveKit](https://github.com/Sajjon/EllipticCurveKit). This SDK uses Zilliqas [JSON-RPC API](https://apidocs.zilliqa.com/#introduction)

# Installation
Zesame uses the JSON-RPC API and not the protobuf API, however, for the packaging of the transaction we need to use protobuf. Please not that protocolbuffers is **only** used for the *packaging of the transaction*, it is not used at all for any communication with the API. All data is sent as JSON to the JSON-RPC API.

## Protobuf
We use the apple/swift-protobuf project for protocol buffers, and it is important to note two different programs associated with swift protobuf:

### Install protobuf
#### `protoc-gen-swift`
This program is used only for generating our swift files from our `.proto` files and we install this program using [brew](https://brew.sh/) (it can also be manually downloaded and built). Follow [installation instructions using brew here](https://github.com/apple/swift-protobuf#alternatively-install-via-homebrew). After this is done we can generate `.pb.swift` files using;

```bash
$ protoc --swift_out=. my.proto
```

#### `SwiftProtobuf` library
In order to make use of our generated `.pb.swift` files we need to include the `SwiftProtobuf` library, which we can do using cocoapods or carhage.

### Use protobuf

Stand in the root of the project and run:

```bash
protoc --swift_opt=Visibility=Public --swift_out=. Source/Models/Protobuf/messages.proto
```

Add the generated file `messages.pb.swift` to corresponding Xcode group.

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
