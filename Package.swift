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
	package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", revision: "d924b9ad27d2a2ccb0ada2639f5255084ff63382"), // later than 0.33.1, fixes WithViewStore bugs, see: https://github.com/pointfreeco/swift-composable-architecture/issues/1022 and PR https://github.com/pointfreeco/swift-composable-architecture/pull/1015
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
			category: .view,
			package: .package(url: "https://github.com/EFPrefix/EFQRCode.git", from: "6.2.0"),
			product: "EFQRCode",
			rationale: "Convenient QR code generator supporting macOS and iOS."
		),
		.init(
			category: .view,
			package: .package(url: "https://github.com/Sajjon/CodeScanner.git", branch: "main"),
			product: .product(name: "CodeScanner", package: "CodeScanner"),
			rationale: "Convenient QR code scanning view."
		)
]

let package = Package(
	name: "Zhip",
	platforms: [.macOS(.v12), .iOS(.v15)],
	products: [
		// Sort alphabetically
		.library(name: "AmountFormatter", targets: ["AmountFormatter"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "BackUpKeystoreFeature", targets: ["BackUpKeystoreFeature"]),
		.library(name: "BackUpPrivateKeyFeature", targets: ["BackUpPrivateKeyFeature"]),
		.library(name: "BackUpPrivateKeyAndKeystoreFeature", targets: ["BackUpPrivateKeyAndKeystoreFeature"]),
		.library(name: "BackUpRevealedKeyPairFeature", targets: ["BackUpRevealedKeyPairFeature"]),
		.library(name: "BackUpWalletFeature", targets: ["BackUpWalletFeature"]),
		.library(name: "Checkbox", targets: ["Checkbox"]),
		.library(name: "Common", targets: ["Common"]),
		.library(name: "DecryptKeystoreFeature", targets: ["DecryptKeystoreFeature"]),
		.library(name: "EnsurePrivacyFeature", targets: ["EnsurePrivacyFeature"]),
		.library(name: "GenerateNewWalletFeature", targets: ["GenerateNewWalletFeature"]),
		.library(name: "HoverPromptTextField", targets: ["HoverPromptTextField"]),
		.library(name: "InputField", targets: ["InputField"]),
		.library(name: "KeychainClient", targets: ["KeychainClient"]),
		.library(name: "KeychainManager", targets: ["KeychainManager"]),
		.library(name: "MainFeature", targets: ["MainFeature"]),
		.library(name: "NewPINFeature", targets: ["NewPINFeature"]),
		.library(name: "NewWalletFeature", targets: ["NewWalletFeature"]),
		.library(name: "NewWalletOrRestoreFeature", targets: ["NewWalletOrRestoreFeature"]),
		.library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
		.library(name: "PasswordInputFields", targets: ["PasswordInputFields"]),
		.library(name: "PINCode", targets: ["PINCode"]),
		.library(name: "PINField", targets: ["PINField"]),
		.library(name: "RestoreWalletFeature", targets: ["RestoreWalletFeature"]),
		.library(name: "QRCoding", targets: ["QRCoding"]),
		.library(name: "Screen", targets: ["Screen"]),
		.library(name: "SetupWalletFeature", targets: ["SetupWalletFeature"]),
		.library(name: "SplashFeature", targets: ["SplashFeature"]),
		.library(name: "Styleguide", targets: ["Styleguide"]),
		.library(name: "TermsOfServiceFeature", targets: ["TermsOfServiceFeature"]),
		.library(name: "TransactionIntent", targets: ["TransactionIntent"]),
		.library(name: "UnlockAppFeature", targets: ["UnlockAppFeature"]),
		.library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
		.library(name: "VersionFeature", targets: ["VersionFeature"]),
		.library(name: "Wallet", targets: ["Wallet"]),
		.library(name: "WalletGenerator", targets: ["WalletGenerator"]),
		.library(name: "WalletGeneratorLive", targets: ["WalletGeneratorLive"]),
		.library(name: "WalletGeneratorUnsafeFast", targets: ["WalletGeneratorUnsafeFast"]),
		.library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
		.library(name: "ZilliqaAPIEndpoint", targets: ["ZilliqaAPIEndpoint"]),
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
					"KeychainClient",
					"MainFeature",
					"OnboardingFeature",
					"Styleguide",
					"SplashFeature",
					"UserDefaultsClient",
					"WalletGeneratorLive",
				]
			),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: ["AppFeature"]
		),
		
		
			.target(
				name: "BackUpKeystoreFeature",
				dependencies: [
					composableArchitecture,
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "BackUpPrivateKeyFeature",
				dependencies: [
					composableArchitecture,
					"DecryptKeystoreFeature",
					"BackUpRevealedKeyPairFeature",
				]
			),
		
		
		.target(
			name: "BackUpPrivateKeyAndKeystoreFeature",
			dependencies: [
				"BackUpKeystoreFeature",
				"BackUpPrivateKeyFeature",
				"Checkbox",
				composableArchitecture,
				"Screen",
				"Styleguide",
			]
		),
		
			.target(
				name: "BackUpRevealedKeyPairFeature",
				dependencies: [
					composableArchitecture,
					"Screen",
					"Styleguide",
				]
			),
		
			.target(
				name: "BackUpWalletFeature",
				dependencies: [
					"BackUpPrivateKeyAndKeystoreFeature",
					"Checkbox",
					composableArchitecture,
					"InputField",
					"Screen",
					"Styleguide",
					"Wallet",
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
				name: "DecryptKeystoreFeature",
				dependencies: [
					composableArchitecture,
					"InputField",
					"Screen",
					"Styleguide",
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
					"PasswordInputFields",
					"Screen",
					"Styleguide",
					"Wallet",
					"WalletGenerator",
				]
			),
		
			.target(
				name: "HoverPromptTextField",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "InputField",
				dependencies: [
					"Styleguide",
					"HoverPromptTextField",
				]
			),
		
			.target(
				name: "KeychainClient",
				dependencies: [
					"KeychainManager", // Wrapper around Keychain,
					"PINCode",
					"Wallet",
					zesame, // ZilAmount (cached balance)
				]
			),
		
			.target(
				name: "KeychainManager",
				dependencies: [
					"KeychainAccess",
					"Wallet",
				]
			),
		
			.target(
				name: "MainFeature",
				dependencies: [
					composableArchitecture,
					"PINCode",
					"UnlockAppFeature",
					"Wallet",
				]
			),

			.target(
				name: "NewPINFeature",
				dependencies: [
					composableArchitecture,
					"KeychainClient",
					"PINField",
					"Styleguide",
					"Screen",
				]
			),
		
			.target(
				name: "NewWalletFeature",
				dependencies: [
					"BackUpWalletFeature",
					composableArchitecture,
					"EnsurePrivacyFeature",
					"GenerateNewWalletFeature",
					"KeychainClient",
					"WalletGenerator",
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
					"KeychainClient",
					"NewPINFeature",
					"SetupWalletFeature",
					"TermsOfServiceFeature",
					"UserDefaultsClient",
					"WelcomeFeature",
					"WalletGenerator",
				]
			),
		
		
			.target(
				name: "PasswordInputFields",
				dependencies: [
					"InputField",
					"HoverPromptTextField",
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
				name: "RestoreWalletFeature",
				dependencies: [
					composableArchitecture,
					"EnsurePrivacyFeature",
					"InputField",
					"Screen",
					"Styleguide",
					"Wallet",
					zesame,
				]
			),
		
			.target(
				name: "QRCoding",
				dependencies: [
					"EFQRCode",
					"Styleguide",
					"TransactionIntent",
					"Wallet",
				]
			),
		
			.target(
				name: "Screen",
				dependencies: [
					"Styleguide",
				]
			),
		
			.target(
				name: "SetupWalletFeature",
				dependencies: [
					composableArchitecture,
					"KeychainClient",
					"NewWalletOrRestoreFeature",
					"NewWalletFeature",
					"RestoreWalletFeature",
					"Screen",
					"Styleguide",
					"Wallet",
					"WalletGenerator"
				]
			),
		
			.target(
				name: "SplashFeature",
				dependencies: [
					composableArchitecture,
					"KeychainClient",
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
				],
				resources: [
					.process("Resources/")
				]
			),
		
			.target(
				name: "UnlockAppFeature",
				dependencies: [composableArchitecture]
			),
		
			.target(
				name: "UserDefaultsClient",
				dependencies: [composableArchitecture]
			),
		
		
			.target(
				name: "VersionFeature",
				dependencies: [
					composableArchitecture,
				]
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
				name: "WalletGenerator",
				dependencies: [
					"Common",
					composableArchitecture,
					"Wallet",
				]
			),
		
			.target(
				name: "WalletGeneratorLive",
				dependencies: [
					"WalletGenerator",
					zesame,
				]
			),
		
			.target(
				name: "WalletGeneratorUnsafeFast",
				dependencies: [
					"WalletGenerator",
					zesame
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
				name: "ZilliqaAPIEndpoint",
				dependencies: [
					zesame,
				]
			),
		
	]
)
