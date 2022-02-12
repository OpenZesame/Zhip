// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Dep. Navigation / UI
private let dependenciesNavigationOrUI: [Package.Dependency] = [
    .package(url: "https://github.com/rundfunk47/stinsen", from: "2.0.7")
]

// MARK: - Dep. Other
private let dependenciesNonUI: [Package.Dependency] = [
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
]

// MARK: - Dependencies
// MARK: -
private let dependencies: [Package.Dependency] = dependenciesNavigationOrUI + dependenciesNonUI

// MARK: - Target Dependency
// MARK: -
private let zhipTargetDependencies: [PackageDescription.Target.Dependency] = [
    "KeychainAccess",
    .product(name: "Stinsen", package: "stinsen"),
]

let package = Package(
    name: "ZhipEngine",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZhipEngine",
            targets: ["ZhipEngine"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZhipEngine",
            dependencies: zhipTargetDependencies),
        .testTarget(
            name: "ZhipEngineTests",
            dependencies: ["ZhipEngine"]),
    ]
)
