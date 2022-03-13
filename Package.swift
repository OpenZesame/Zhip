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

private let zesameDependency: Dependency = .init(
		category: .essential,
		// branch: structured_concurrency
		package: .package(url: "https://github.com/OpenZesame/zesame.git", revision: "8918ddb06807724383ad2965461fffeea91f89af"),
		product: .product(name: "Zesame", package: "zesame"),
		rationale: "Zilliqa Swift SDK, containing all account logic."
)
private let zesame = zesameDependency.product

private let composableArchitectureDependency: Dependency = .init(
	category: .architecture,
	package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.33.1"),
	product: .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
	rationale: "Testable, modular, scalable architecture gaining grounds as the go-to architecture for SwiftUI."
)
private let composableArchitecture = composableArchitectureDependency.product

private let dependencies: [Dependency] = [

		zesameDependency,
		composableArchitectureDependency,
	
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
		// Sort alphabetically
		.library(name: "AmountFormatter", targets: ["AmountFormatter"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "BackUpWalletFeature", targets: ["BackUpWalletFeature"]),
		.library(name: "Checkbox", targets: ["Checkbox"]),
		.library(name: "Common", targets: ["Common"]),
		.library(name: "EnsurePrivacyFeature", targets: ["EnsurePrivacyFeature"]),
		.library(name: "GenerateNewWalletFeature", targets: ["GenerateNewWalletFeature"]),
		.library(name: "HoverPromptTextField", targets: ["HoverPromptTextField"]),
		.library(name: "InputField", targets: ["InputField"]),
		.library(name: "KeychainManager", targets: ["KeychainManager"]),
		.library(name: "KeyValueStore", targets: ["KeyValueStore"]),
		.library(name: "NewPINFeature", targets: ["NewPINFeature"]),
		.library(name: "NewWalletFeature", targets: ["NewWalletFeature"]),
		.library(name: "NewWalletOrRestoreFeature", targets: ["NewWalletOrRestoreFeature"]),
		.library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
		.library(name: "PINCode", targets: ["PINCode"]),
		.library(name: "PINField", targets: ["PINField"]),
		.library(name: "Preferences", targets: ["Preferences"]),
		.library(name: "RestoreWalletFeature", targets: ["RestoreWalletFeature"]),
		.library(name: "QRCoding", targets: ["QRCoding"]),
		.library(name: "Screen", targets: ["Screen"]),
		.library(name: "SecurePersistence", targets: ["SecurePersistence"]),
		.library(name: "SetupWalletFeature", targets: ["SetupWalletFeature"]),
		.library(name: "Styleguide", targets: ["Styleguide"]),
		.library(name: "TermsOfServiceFeature", targets: ["TermsOfServiceFeature"]),
		.library(name: "TransactionIntent", targets: ["TransactionIntent"]),
		.library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
		.library(name: "Wallet", targets: ["Wallet"]),
		.library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
		.library(name: "ZilliqaAPIEndpoint", targets: ["ZilliqaAPIEndpoint"]),
		.library(name: "ZhipEngine", targets: ["ZhipEngine"]),
	],
	dependencies: dependencies.packageDependencies,
	targets: [
		// Sort alphabetically
		.target(
			name: "AmountFormatter",
			dependencies: [
				"Common",
				zesame,
			]
		),
		
			.target(
				name: "AppFeature",
				dependencies: [
					composableArchitecture,
					"OnboardingFeature",
					"Styleguide",
					"UserDefaultsClient",
				]
			),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: ["AppFeature"]
		),
		
		
			.target(
				name: "BackUpWalletFeature",
				dependencies: [
					"Checkbox",
					composableArchitecture,
					"InputField",
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "Checkbox",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "Common",
				dependencies: [
					zesame,
				]
			),
		
			.target(
				name: "EnsurePrivacyFeature",
				dependencies: [
					composableArchitecture,
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "GenerateNewWalletFeature",
				dependencies: [
					"Checkbox",
					composableArchitecture,
					"HoverPromptTextField",
					"InputField",
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "HoverPromptTextField",
				dependencies: [
					"Styleguide"
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
				name: "KeychainManager",
				dependencies: [
					"Wallet",
					"KeyValueStore"
				]
			),
		
			.target(
				name: "KeyValueStore",
				dependencies: [
				]
			),

			.target(
				name: "NewPINFeature",
				dependencies: [
					composableArchitecture,
					"PINField",
					"Styleguide",
					"Screen",
				]
			),
		
			.target(
				name: "NewWalletFeature",
				dependencies: [
					composableArchitecture,
					"EnsurePrivacyFeature",
					"GenerateNewWalletFeature",
					"BackUpWalletFeature",
				]
			),
			
		
			.target(
				name: "NewWalletOrRestoreFeature",
				dependencies: [
					composableArchitecture,
					"Styleguide",
					"Screen",
				]
			),
		
			.target(
				name: "OnboardingFeature",
				dependencies: [
					composableArchitecture,
					"SetupWalletFeature",
					"TermsOfServiceFeature",
					"UserDefaultsClient",
					"WelcomeFeature",
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
				name: "PINField",
				dependencies: [
					"HoverPromptTextField",
					"PINCode",
					"Styleguide",
				]
			),
		
			.target(
				name: "Preferences",
				dependencies: [
					"KeyValueStore",
				]
			),
		
			.target(
				name: "RestoreWalletFeature",
				dependencies: [
					composableArchitecture,
					"EnsurePrivacyFeature",
					"InputField",
					"Screen",
					"Styleguide",
					zesame,
				]
			),
		
			.target(
				name: "QRCoding",
				dependencies: [
					"Styleguide",
					"TransactionIntent",
				]
			),
		
			.target(
				name: "Screen",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "SecurePersistence",
				dependencies: [
					"KeychainManager",
				]
			),
		
		
			.target(
				name: "SetupWalletFeature",
				dependencies: [
					composableArchitecture,
					"NewPINFeature",
					"NewWalletOrRestoreFeature",
					"NewWalletFeature",
					"RestoreWalletFeature",
					"Screen",
					"Styleguide",
					"Wallet",
				]
			),
		
			.target(
				name: "Styleguide",
				dependencies: [
					composableArchitecture
				]
			),
		
			.target(
				name: "TransactionIntent",
				dependencies: [
					zesame
				]
			),
		
			.target(
				name: "TermsOfServiceFeature",
				dependencies: [
					composableArchitecture,
					"Screen",
					"UserDefaultsClient",
					zesame,
				]
			),
		
			.target(
				name: "UserDefaultsClient",
				dependencies: [composableArchitecture]
			),
		
			.target(
				name: "Wallet",
				dependencies: [
					"Common",
					zesame,
					"ZilliqaAPIEndpoint",
				]
			),
		
			.target(
				name: "WelcomeFeature",
				dependencies: [
					composableArchitecture,
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "ZhipEngine",
				dependencies: dependencies.targetDependencies + [
					"AmountFormatter",
					"Checkbox",
					"InputField",
					"PINCode",
					"PINField",
					"Preferences",
					"QRCoding",
					"Screen",
					"SecurePersistence",
					"Wallet",
				]
			),
		.testTarget(
			name: "ZhipEngineTests",
			dependencies: ["ZhipEngine"]
		),
		
			.target(
				name: "ZilliqaAPIEndpoint",
				dependencies: [
					zesame,
				]
			),
		
	]
)
