![ZhipLogo](zhip-logo.png)

![Build Status](https://app.bitrise.io/app/257ea698a1e55eec/status.svg?token=Cy4YjEgbtcNYxkJqTtNX3Q&branch=develop)

[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Zhip
Zhip is the worlds first and only iOS wallet for Zilliqa. The app is entirely open source. It uses the [Zilliqa Swift SDK "Zesame"](https://github.com/OpenZesame/Zesame).

# Getting started
-  Xcode 10
- Clone this repo

*Since cocoapods* folder `Pods/` is under version control and thus downloaded when you cloned this repo the following tools are optional but needed if you would like to add a new pod.

You can thus get started right away:
```bash
open Zhip.xcworkspace
```

## Optional
- Install [brew](https://brew.sh/)
- Install [rbenv](https://github.com/rbenv/rbenv)
- Install [Bundler](https://bundler.io/)

# Architecture
This app uses a novel architecture named *SLC: Single-Line Controller*, I **strongly** suggest that you begin by reading [this medium article about it](https://medium.com/@sajjon/single-line-controller-fbe474857787) and make sure to [read the second part](https://medium.com/@sajjon/single-line-controller-advanced-case-406e76731ee6) as well.

It is a kind of MVVM where the `UIViewController` in most cases is one single line and all view and flow of data logic is put in the ViewModel. It also uses the [Coordinator pattern](http://khanlou.com/2015/10/coordinators-redux/).

# Dependencies
You will find all dependencies inside the [Podfile](https://github.com/OpenZesame/Zhip/blob/develop/Podfile), but to mention the most important:

## Zesame
This iOS wallet is entirely dependent on the [Zilliqa Swift SDK known as Zesame](https://github.com/OpenZesame/Zesame), without that this wallet couldn't exist. All cryptographic methods and all interaction with the Zilliqa Ledger through their [API](https://apidocs.zilliqa.com/#introduction) is done using Zesame.

## EllipticCurveKit
In turn, Zesame is dependent on the Elliptic Curve Cryptography of [EllipticCurveKit]((https://github.com/Sajjon/EllipticCurveKit)), for the generation of new wallets, restoration of existing ones, the encryption of your private keys into keystores and the signing of your transactions using [Schnorr Signatures](https://en.wikipedia.org/wiki/Schnorr_signature).

## Other

- [RxSwift](https://github.com/ReactiveX/RxSwift): The library uses RxSwift for async programming.

- [EFQRCode](https://github.com/EFPrefix/EFQRCode): Generate QR codes.

- [QRCodeReader.swift](https://github.com/yannickl/QRCodeReader.swift): Scanning QR codes.


# Privacy
When starting the app for the first time you will be asked to opt-in or opt-out for crashreporting. 

If you chose to opt in and would like to opt out at a later time - or the other way around - you can do so from Settings at any time. 

If you choose to opt out Crashlytics will not be initialized and no crash reports will be sent from your app. 

If you chose to opt in it will make it easier to fix potential bugs in the apps, especially those crucial ones resulting in crashes. Crashlytics has been added for this sole purpose, make the app more reliable and less likely to crash. 

## Disabled by default
Open the file [Zhip-Info.plist](Source/Application/Zhip-Info.plist) and you will see that the value for the key `firebase_crashlytics_collection_enabled` is set to `false`, which is the [documented way of turning of crash reports by default](https://firebase.google.com/docs/crashlytics/customize-crash-reports)

When the app starts it checks if you accepted crash reporting, you can verify this by looking in the file [Bootstrap.swift](Source/Application/Utils/Bootstrap.swift) 
```swift
func setupCrashReportingIfAllowed() {
    guard Preferences.default.isTrue(.hasAcceptedCrashReporting)
```

And searching in the code for [`"for .hasAcceptedCrashReporting"`](https://github.com/OpenZesame/Zhip/search?l=Swift&q=%22for%3A+.hasAcceptedCrashReporting%22) shows when and how the boolean flag `hasAcceptedCrashReporting` gets written.

## Analytics not used
In the function `setupCrashReportingIfAllowed` in `Bootstrap.swift` you will see calls to `Firebase`:
```swift
    FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
    FirebaseApp.configure()
    Fabric.with([Crashlytics.self])
```
Firebase analytics is not used, but Crashlytics is setup using Firebase.

You can search for `Analytics.logEvent` or `Analytics.setScreenName` in the code and you will not find any search results.

# Donate
This **free** wallet and the foundation Zesame its built upon has been developed by the single author Alexander Cyon without paid salary in his free time - approximatly **a thousand hours of work** since May 2018 ([see initial commit in Zesame](https://github.com/OpenZesame/Zesame/commit/d948741f3e3d38a9962cc9a23552622a303e7ff4)). 

**Any donation would be much appreciated**:

- BTC: 3GarsdAzLpEYbhkryYz1WiZxhtTLLaNJwo
- ETH: 0xAB8F0137295BFE37f50b581F76418518a91ab8DB
- NEO: AbbnnCLP26ccSnLooDDcwPLDnfXbVL5skH

# License

**Zhip** is released under the [MIT License](LICENSE).

# Acknowledgments
Sound effect when transaction is sent is called ["RADAR"](https://freesound.org/people/MATTIX/sounds/445723/) by [Mattias "MATTIX" Lahoud](https://freesound.org/people/MATTIX/) under [CreativeCommons](https://creativecommons.org/licenses/by/3.0/), thanks a lot!

