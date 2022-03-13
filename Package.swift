// swift-tools-version:5.6
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
		.library(name: "Common", targets: ["Common"]),
		.library(name: "KeychainManager", targets: ["KeychainManager"]),
		.library(name: "KeyValueStore", targets: ["KeyValueStore"]),
		.library(name: "SecurePersistence", targets: ["SecurePersistence"]),
		.library(name: "ZilliqaAPIEndpoint", targets: ["ZilliqaAPIEndpoint"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "Wallet", targets: ["Wallet"]),
		.library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
		.library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
		.library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
		.library(name: "PINCode", targets: ["PINCode"]),
		.library(name: "PINField", targets: ["PINField"]),
		.library(name: "Screen", targets: ["Screen"]),
		.library(name: "QRCoding", targets: ["QRCoding"]),
		.library(name: "TransactionIntent", targets: ["TransactionIntent"]),
		.library(name: "Checkbox", targets: ["Checkbox"]),
		.library(name: "InputField", targets: ["InputField"]),
		.library(name: "Preferences", targets: ["Preferences"]),
		.library(name: "AmountFormatter", targets: ["AmountFormatter"]),
		.library(name: "HoverPromptTextField", targets: ["HoverPromptTextField"]),
		.library(name: "Styleguide", targets: ["Styleguide"]),
		.library(
			name: "ZhipEngine",
			targets: ["ZhipEngine"]),
	],
	dependencies: dependencies.packageDependencies,
	targets: [
		
		.target(
			name: "ZhipEngine",
			dependencies: dependencies.targetDependencies + [
				"PINCode",
				"Wallet",
				"SecurePersistence",
				"Preferences",
				"AmountFormatter",
				"QRCoding",
				"InputField",
				"PINField",
				"Screen",
				"Checkbox"
			]
		),
		.testTarget(
			name: "ZhipEngineTests",
			dependencies: ["ZhipEngine"]
		),
		
		.target(
			name: "PINField",
			dependencies: [
				"PINCode",
				"Styleguide",
				"HoverPromptTextField"
			]
		),
		
			.target(
				name: "InputField",
				dependencies: [
					"Styleguide",
					"HoverPromptTextField"
				]
			),
		
			.target(
				name: "Common",
				dependencies: [
					.product(name: "Zesame", package: "zesame"),
				]
			),
		
			.target(
				name: "KeyValueStore",
				dependencies: [
				]
			),
		
			.target(
				name: "KeychainManager",
				dependencies: [
					"Wallet",
					"KeyValueStore"
				]
			),
		
			.target(
				name: "SecurePersistence",
				dependencies: [
					"KeychainManager",
				]
			),
		
			.target(
				name: "Preferences",
				dependencies: [
					"KeyValueStore",
				]
			),
		
			.target(
				name: "Screen",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "PINCode",
				dependencies: []
			),
		.testTarget(
			name: "PINCodeTests",
			dependencies: ["PINCode"]
		),
		
			.target(
				name: "TransactionIntent",
				dependencies: [
					.product(name: "Zesame", package: "zesame")
				]
			),
		
			.target(
				name: "QRCoding",
				dependencies: [
					"TransactionIntent",
					"Styleguide",
				]
			),
		
		
			.target(
				name: "ZilliqaAPIEndpoint",
				dependencies: [
					.product(name: "Zesame", package: "zesame"),
				]
			),
		
			.target(
				name: "Checkbox",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "Wallet",
				dependencies: [
					.product(name: "Zesame", package: "zesame"),
					"Common",
					"ZilliqaAPIEndpoint",
				]
			),
		
		.target(
			name: "HoverPromptTextField",
			dependencies: [
				"Styleguide"
			]
		),
		
		.target(
			name: "Styleguide",
			dependencies: [
				tca.product
			]
		),
		

			.target(
				name: "AmountFormatter",
				dependencies: [
					.product(name: "Zesame", package: "zesame"),
					"Common",
				]
			),

		
		.target(
			name: "WelcomeFeature",
			dependencies: [
				tca.product,
				"Styleguide",
				"Screen"
			]
		),
	//		.testTarget(
	//			name: "WelcomeFeatureTests",
	//			dependencies: ["WelcomeFeature"]
	//		),
		.target(
			name: "OnboardingFeature",
			dependencies: [
				tca.product,
				"WelcomeFeature",
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
