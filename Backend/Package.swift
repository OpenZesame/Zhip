// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import QuartzCore

struct Dependency {
    enum Category {
        case essential
        case navigation
        case view
        case `convenience`
    }
    let category: Category
    let package: Package.Dependency
    let product: PackageDescription.Target.Dependency
    let rationale: String
}
extension Array where Element == Dependency {
    var packageDependencies: [Package.Dependency] { map { $0.package } }
    var targetDependencies: [PackageDescription.Target.Dependency] { map { $0.product } }
}

private let dependencies: [Dependency] = [
    .init(
        category: .essential,
        package: .package(url: "https://github.com/OpenZesame/zesame.git", branch: "structured_concurrency"),
        product: .product(name: "Zesame", package: "zesame"),
        rationale: "Zilliqa Swift SDK, containing all account logic."
    ),
    
    .init(
        category: .convenience,
        package: .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        product: "KeychainAccess",
        rationale: "Keychain is very low level"
    ),
    
    .init(
        category: .navigation,
        package: .package(url: "https://github.com/rundfunk47/stinsen", from: "2.0.7"),
        product: .product(name: "Stinsen", package: "stinsen"),
        rationale: "Coordinator pattern"
    ),
    
    .init(
        category: .view,
        package: .package(url: "https://github.com/Sajjon/FloatingLabelTextFieldSwiftUI.git", branch: "main"),
        product: "FloatingLabelTextFieldSwiftUI",
        rationale: "Saves me lots of work implementing floating label with validation and error messages."
    )
    
//    .init(
//        category: .navigation,
//        package: .package(url: "https://github.com/matteopuc/swiftui-navigation-stack", from: "1.0.4"),
//        product: "NavigationStack",
//        rationale: "Manual control over navigation stack"
//    )
    
//    .init(
//        category: .navigation,
//        package: .package(url: "https://github.com/pointfreeco/swiftui-navigation", branch: "main"),
//        product: "SwiftUINavigation",
//        rationale: "Routing and IfLet Switch, CaseLet convenience"
//    )

//    .init(
//        category: .navigation,
//        package: .package(url: "https://github.com/johnpatrickmorgan/FlowStacks", from: "0.1.0"),
//        product: "FlowStacks",
//        rationale: "Coordinator pattern and routing"
//    )
  
]

let package = Package(
    name: "ZhipEngine",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZhipEngine",
            targets: ["ZhipEngine"]),
    ],
    dependencies: dependencies.packageDependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZhipEngine",
            dependencies: dependencies.targetDependencies),
        .testTarget(
            name: "ZhipEngineTests",
            dependencies: ["ZhipEngine"]),
    ]
)
