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
When starting the app for the first time you will be asked to opt-in or opt-out for analytics. Currently, you cannot opt in for just crash reporting but not analytics events, you opt-in for both or neither. 

If you chose to opt in and would like to opt out at a later time - or the other way around - you can do so from Settings at any time. 

If you choose to opt out neither Google Firebase Analytics nor Firebase (former Fabric) Crashlytics will be initialized and no analytics events and no crash reports will be sent from your app. 

## Crash reports
If you chose to opt in it will make it easier to fix potential bugs in the apps, especially those crucial ones resulting in crashes. Crashlytics has been added for this sole purpose, make the app more reliable and less likely to crash. 

## Analytics
If you are curious which events are being tracked, it is button taps and screen events - **no sensitive data is ever being saved/sent to Google**, you can verify this yourself by [searchin here on Github in this repo for "TrackableEvent"](https://github.com/OpenZesame/Zhip/search?q=TrackableEvent). You can also find the two instances in the code where events are being sent by [searching for "Firebase.Analytics" in Swift files](https://github.com/OpenZesame/Zhip/search?l=Swift&q=%22Firebase.Analytics%22). Both calls appear after this line respectively: 
```swift
guard preferences.isTrue(.hasAcceptedAnalyticsTracking) else { return }
```

And searching in the code for [`save(value: acceptsTracking, for: .hasAcceptedAnalyticsTracking)`](https://github.com/OpenZesame/Zhip/search?q=%22save%28value%3A+acceptsTracking%2C+for%3A+.hasAcceptedAnalyticsTracking%29%22&unscoped_q=%22save%28value%3A+acceptsTracking%2C+for%3A+.hasAcceptedAnalyticsTracking%29%22) shows when and how the boolean flag `hasAcceptedAnalyticsTracking` gets written.


# Donate
This **free** wallet and the foundation Zesame its built upon has been developed by the single author Alexander Cyon without paid salary in his free time - approximatly **a thousand hours of work** since May 2018 ([see initial commit in Zesame](https://github.com/OpenZesame/Zesame/commit/d948741f3e3d38a9962cc9a23552622a303e7ff4)). 

**Any donation would be much appreciated**:

- BTC: 3GarsdAzLpEYbhkryYz1WiZxhtTLLaNJwo
- ETH: 0xAB8F0137295BFE37f50b581F76418518a91ab8DB
- NEO: AbbnnCLP26ccSnLooDDcwPLDnfXbVL5skH

# License

**Zhip** is released under the [MIT License](LICENSE).
