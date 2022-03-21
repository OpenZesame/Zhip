![ZhipLogo](zhip-logo.png)

![Build Status](https://app.bitrise.io/app/257ea698a1e55eec/status.svg?token=Cy4YjEgbtcNYxkJqTtNX3Q&branch=develop)

[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Zhip
This is the open source code code for the [iOS wallet app Zhip (App Store link)](https://apps.apple.com/us/app/zhip/id1455248315). Zhip is the worlds first iOS wallet for Zilliqa. It uses the [Zilliqa Swift SDK "Zesame"](https://github.com/OpenZesame/Zesame).

# Getting started
- Xcode 13.3 (Xcode 12 might work as well.)
- Clone this repo

You can thus get started right away:
```sh
open Zhip.xcodeproj
```

## Optional
- Install [brew](https://brew.sh/)
- Install [SwiftLint](https://github.com/realm/SwiftLint) (using brew)
- Install [SwiftGen](https://github.com/SwiftGen/SwiftGen) (using brew)

# Architecture
This app uses a novel architecture named *SLC: Single-Line Controller*, I **strongly** suggest that you begin by reading [this medium article about it](https://medium.com/@sajjon/single-line-controller-fbe474857787) and make sure to [read the second part](https://medium.com/@sajjon/single-line-controller-advanced-case-406e76731ee6) as well.

It is a kind of MVVM where the `UIViewController` in most cases is one single line and all view and flow of data logic is put in the ViewModel. It also uses the [Coordinator pattern](http://khanlou.com/2015/10/coordinators-redux/).

# Dependencies
You will find all dependencies inside the list of SPM packages in Xcode -> Project *Zhip* -> *Swift Packages* (or by *Show the Project navigator* and under *Swift Package Dependencies*), but here are the most important ones.

## Zesame
This iOS wallet is entirely dependent on the [Zilliqa Swift SDK known as `Zesame`](https://github.com/OpenZesame/Zesame), without that this wallet couldn't exist. All cryptographic methods and all interaction with the Zilliqa Ledger through their [API](https://apidocs.zilliqa.com/#introduction) is done using `Zesame`.

## EllipticCurveKit
In turn, `Zesame` is dependent on the Elliptic Curve Cryptography of [EllipticCurveKit]((https://github.com/Sajjon/EllipticCurveKit)), for the generation of new wallets, restoration of existing ones, the encryption of your private keys into keystores and the signing of your transactions using [Schnorr Signatures](https://en.wikipedia.org/wiki/Schnorr_signature).

## Other

- [RxSwift](https://github.com/ReactiveX/RxSwift): The library uses RxSwift for async programming.

- [EFQRCode](https://github.com/EFPrefix/EFQRCode): Generate QR codes.

- [QRCodeReader.swift](https://github.com/yannickl/QRCodeReader.swift): Scanning QR codes.


# Privacy
This app does not send any of your data **at all**, to any third party. Previous versions of Zhip used analytics to help with us with debugging. Analytics was completely removed in version 2.0.0. Search the code base for analytics and you will not find any.

# Donate
This **free** wallet and the foundation Zesame its built upon has been developed by the single author Alexander Cyon without paid salary in his free time - approximatly **a thousand hours of work** since May 2018 ([see initial commit in Zesame](https://github.com/OpenZesame/Zesame/commit/d948741f3e3d38a9962cc9a23552622a303e7ff4)). 

**Any donation would be much appreciated**:

- ZIL: zil108t2jdgse760d88qjqmffhe9uy0nk4wvzx404t
- BTC: 3GarsdAzLpEYbhkryYz1WiZxhtTLLaNJwo
- ETH: 0xAB8F0137295BFE37f50b581F76418518a91ab8DB
- NEO: AbbnnCLP26ccSnLooDDcwPLDnfXbVL5skH

# License

**Zhip** is released under the [MIT License](LICENSE).

# Acknowledgments
Sound effect when transaction is sent is called ["RADAR"](https://freesound.org/people/MATTIX/sounds/445723/) by [Mattias "MATTIX" Lahoud](https://freesound.org/people/MATTIX/) under [CreativeCommons](https://creativecommons.org/licenses/by/3.0/), thanks a lot!

