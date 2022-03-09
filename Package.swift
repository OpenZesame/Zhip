// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Dependency {
	enum Category {
		case essential
		case architecture
		case navigation
		case view
		case `convenience`
	}
	let category: Category
	let package: Package.Dependency
	let product: PackageDescription.Target.Dependency
	let rationale: String
	
	struct Alternative: ExpressibleByStringLiteral {
		init(stringLiteral value: String) {
			self.init(url: value)
		}
		let url: String
		let abstract: String?
		init(url: String, abstract: String? = nil) {
			self.url = url
			self.abstract = abstract
		}
	}
	
	let alternatives: [Alternative]
	init(
		category: Category,
		package: Package.Dependency,
		product: PackageDescription.Target.Dependency,
		rationale: String,
		alternatives: [Alternative] = []
	) {
		self.category = category
		self.package = package
		self.product = product
		self.rationale = rationale
		self.alternatives = alternatives
	}
}
extension Array where Element == Dependency {
	var packageDependencies: [Package.Dependency] { map { $0.package } }
	var targetDependencies: [PackageDescription.Target.Dependency] { map { $0.product } }
}

private let tca: Dependency = .init(
	category: .architecture,
	   package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.33.1"),
	   product: .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
	   rationale: "Testable, modular, scalable architecture gaining grounds as the go-to architecture for SwiftUI."
   )

private let dependencies: [Dependency] = [
	.init(
		category: .essential,
		// branch: structured_concurrency
		package: .package(url: "https://github.com/OpenZesame/zesame.git", revision: "8918ddb06807724383ad2965461fffeea91f89af"),
		product: .product(name: "Zesame", package: "zesame"),
		rationale: "Zilliqa Swift SDK, containing all account logic."
	),
	
	tca,

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
		rationale: "Coordinator pattern",
		alternatives: [
			.init(url: "https://github.com/matteopuc/swiftui-navigation-stack", abstract: "Manual control over navigation stack"),
			.init(url: "https://github.com/pointfreeco/swiftui-navigation", abstract: "Routing and IfLet Switch, CaseLet convenience"),
			.init(url: "https://github.com/johnpatrickmorgan/FlowStacks", abstract: "Coordinator pattern and routing")
		]
	),

	.init(
		category: .view,
		package: .package(url: "https://github.com/EFPrefix/EFQRCode.git", from: "6.2.0"),
		product: "EFQRCode",
		rationale: "Convenient QR code generator supporting macOS and iOS."
	),

	.init(
		category: .view,
		package: .package(url: "https://github.com/twostraws/CodeScanner.git", from: "2.1.1"),
		product: .product(name: "CodeScanner", package: "CodeScanner", condition: .when(platforms: [.iOS])),
		rationale: "Convenient QR code scanning view.",
		alternatives: [
			.init(url: "https://github.com/mercari/QRScanner", abstract: "Lacks SwiftUI support?"),
			.init(url: "https://github.com/yannickl/QRCodeReader.swift", abstract: "Lacks SwiftUI support?")
		]
	)
]

let package = Package(
	name: "Zhip",
	platforms: [.macOS(.v12), .iOS(.v15)],
	products: [
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
		.library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
		.library(name: "Styleguide", targets: ["Styleguide"]),
		.library(
			name: "ZhipEngine",
			targets: ["ZhipEngine"]),
	],
	dependencies: dependencies.packageDependencies,
	targets: [
		
		.target(
			name: "ZhipEngine",
			dependencies: dependencies.targetDependencies
		),
		.testTarget(
			name: "ZhipEngineTests",
			dependencies: ["ZhipEngine"]
		),
		
		.target(
			name: "Styleguide",
			dependencies: [
				tca.product
			]
		),
		
		.target(
			name: "OnboardingFeature",
			dependencies: [
				tca.product,
				"UserDefaultsClient"
			]
		),
//		.testTarget(
//			name: "OnboardingFeatureTests",
//			dependencies: ["OnboardingFeature"]
//		),
		
		.target(
			name: "AppFeature",
			dependencies: [
				tca.product,
				"OnboardingFeature",
				"UserDefaultsClient",
				"Styleguide"
			]
		),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: ["AppFeature"]
		),
		
		.target(
			name: "UserDefaultsClient",
			dependencies: [tca.product]
		),
	]
)
