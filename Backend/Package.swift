// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZhipEngine",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZhipEngine",
            targets: ["ZhipEngine"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0")
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZhipEngine",
            dependencies: [
                "KeychainAccess"
//                .product(name: "KeychainSwift", package: "keychain-swift")
            ]),
        .testTarget(
            name: "ZhipEngineTests",
            dependencies: ["ZhipEngine"]),
    ]
)
