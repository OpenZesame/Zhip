# Zesame

Zesame is an *unofficial* Swift SDK for Zilliqa. It is written in Swift 4.2. This SDK contains cryptographic methods allowing you to create and restore a wallet, sign and broadcast transactions. The cryptographic methods are implemented in [EllipticCurveKit](https://github.com/Sajjon/EllipticCurveKit). This SDK uses Zilliqas [JSON-RPC API](https://apidocs.zilliqa.com/#introduction)

# Getting started
- Install [Brew](https://brew.sh/)
- Install [Carthage](https://github.com/Carthage/Carthage/)
- Build Carthage projects
```bash
carthage bootstrap --platform iOS,macOS --cache-builds --no-use-binaries
```

## Protobuf
Zesame uses the JSON-RPC API and not the protobuf API, however, for the packaging of the transaction we need to use protobuf. Please not that protocolbuffers is **only** used for the *packaging of the transaction*, it is not used at all for any communication with the API. All data is sent as JSON to the JSON-RPC API.

We use the [apple/swift-protobuf](https://github.com/apple/swift-protobuf) project for protocol buffers, and it is important to note the two different programs associated with swift protobuf:

### Install protobuf
#### `protoc-gen-swift`
This program is used only for generating our swift files from our `.proto` files and we install this program using [brew](https://brew.sh/) (it can also be manually downloaded and built). 

Follow [installation instructions using brew here](https://github.com/apple/swift-protobuf#alternatively-install-via-homebrew). 
```bash
brew install swift-protobuf
```

After this is done we can generate `.pb.swift` files using

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

# Dependencies
You will find all dependencies inside the [Cartfile](https://github.com/OpenZesame/Zesame/blob/master/Cartfile), but to mention the most important:

## EllipticCurveKit
Zesame is dependent on the Elliptic Curve Cryptography of [EllipticCurveKit]((https://github.com/Sajjon/EllipticCurveKit)), for the generation of new wallets, restoration of existing ones, the encryption of your private keys into keystores and the signing of your transactions using [Schnorr Signatures](https://en.wikipedia.org/wiki/Schnorr_signature).

## Other

- [RxSwift](https://github.com/ReactiveX/RxSwift): The library uses RxSwift for async programming.

- [JSONRPCKit](https://github.com/ollitapa/JSONRPCKit): For consuming the Zilliqa JSON-RPC API.

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

# Explorer
While developing it might be useful for you to use the [Zilliqa explorer](https://explorer.zilliqa.com/home)

# Donate
This SDK and the foundation EllipticCurveKit its built upon has been developed by the single author Alexander Cyon without paid salary in his free time - approximatly **a thousand hours of work** since May 2018 ([see initial commit](https://github.com/OpenZesame/Zesame/commit/d948741f3e3d38a9962cc9a23552622a303e7ff4)). 

**Any donation would be much appreciated**:

- BTC: 3GarsdAzLpEYbhkryYz1WiZxhtTLLaNJwo
- ETH: 0xAB8F0137295BFE37f50b581F76418518a91ab8DB
- NEO: AbbnnCLP26ccSnLooDDcwPLDnfXbVL5skH

# License

**Zhip** is released under the [MIT License](LICENSE).
