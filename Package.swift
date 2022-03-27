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
	package: .package(url: "https://github.com/OpenZesame/Zesame.git", revision: "8918ddb06807724383ad2965461fffeea91f89af"),
	product: .product(name: "Zesame", package: "Zesame"),
	rationale: "Zilliqa Swift SDK, containing all account logic."
)
private let Zesame_ALREADY_DEPENDENCY_FIX_ME = zesameDependency.product

private let composableArchitectureDependency: Dependency = .init(
	category: .architecture,
	package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", revision: "d924b9ad27d2a2ccb0ada2639f5255084ff63382"), // later than 0.33.1, fixes WithViewStore bugs, see: https://github.com/pointfreeco/swift-composable-architecture/issues/1022 and PR https://github.com/pointfreeco/swift-composable-architecture/pull/1015
	product: .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
	rationale: "Testable, modular, scalable architecture gaining grounds as the go-to architecture for SwiftUI."
)
private let ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME = composableArchitectureDependency.product

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

// MARK: - Products (Libraries)
var products: [Product] = []
var targets: [Target] = []

func declare(_ target: Target) -> Target {
	targets.append(target)
	
	if !target.isTest {
		products.append(
			Product.library(name: target.name, targets: [target.name])
		)
	}
	return target
}

extension Array where Element == Target {
	var asDependencies: [Target.Dependency] {
		map { target in
			Target.Dependency(stringLiteral: target.name)
		}
	}
}


// MARK: - AmountFormatter
let AmountFormatter = declare(.target(
	name: "AmountFormatter",
	dependencies: [
		"Common",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - AppFeature
let Appfeature = declare(.target(
	name: "AppFeature",
	dependencies: [
		"Common",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"MainFeature",
		"OnboardingFeature",
		"PasswordValidator",
		"Styleguide",
		"SplashFeature",
		"UserDefaultsClient",
		"WalletGeneratorLive",
		Zesame_ALREADY_DEPENDENCY_FIX_ME
	]
))

// MARK: - TEST AppFeature
let TESTAppFeatures	= declare(.testTarget(
	name: "AppFeatureTests",
	dependencies: [Appfeature].asDependencies
))

// MARK: - BackUpKeystoreFeature
let BackUpKeystoreFeature = declare(.target(
	name: "BackUpKeystoreFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"Styleguide",
	]
))

// MARK: - BackUpPrivateKeyFeature
let BackUpPrivateKeyFeature = declare(.target(
	name: "BackUpPrivateKeyFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"DecryptKeystoreFeature",
		"BackUpRevealedKeyPairFeature",
	]
))

// MARK: - BackUpPrivateKeyAndKeystoreFeature
let BackUpPrivateKeyAndKeystoreFeature = declare(.target(
	name: "BackUpPrivateKeyAndKeystoreFeature",
	dependencies: [
		"BackUpKeystoreFeature",
		"BackUpPrivateKeyFeature",
		"Checkbox",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"Styleguide",
	]
))

// MARK: - BackUpRevealedKeyPairFeature
let BackUpRevealedKeyPairFeature = declare(.target(
	name: "BackUpRevealedKeyPairFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"Styleguide",
	]
))

// MARK: - BackUpWalletFeature
let BackUpWalletFeature = declare(.target(
	name: "BackUpWalletFeature",
	dependencies: [
		"BackUpPrivateKeyAndKeystoreFeature",
		"Checkbox",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"InputField",
		"Screen",
		"Styleguide",
		"Wallet",
	]
))

// MARK: - BalancesFeature
let BalancesFeature = declare(.target(
	name: "BalancesFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Screen",
		"Styleguide",
		"Wallet",
	]
))

// MARK: - Checkbox
let Checkbox = declare(.target(
	name: "Checkbox",
	dependencies: [
		"Styleguide",
	]
))

// MARK: - Common
let Common = declare(.target(
	name: "Common",
	dependencies: [
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - ContactsFeature
let ContactsFeature = declare(.target(
	name: "ContactsFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Screen",
		"Styleguide",
		"Wallet",
	]
))

// MARK: - DecryptKeystoreFeature
let DecryptKeystoreFeature = declare(.target(
	name: "DecryptKeystoreFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"InputField",
		"Screen",
		"Styleguide",
	]
))

// MARK: - EnsurePrivacyFeature
let EnsurePrivacyFeature = declare(.target(
	name: "EnsurePrivacyFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"Styleguide",
	]
))

// MARK: - GenerateNewWalletFeature
let GenerateNewWalletFeature = declare(.target(
	name: "GenerateNewWalletFeature",
	dependencies: [
		"Checkbox",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"HoverPromptTextField",
		"InputField",
		"KeychainClient",
		"PasswordInputFields",
		"PasswordValidator",
		"Screen",
		"Styleguide",
		"Wallet",
		"WalletGenerator",
	]
))
// MARK: - TEST GenerateNewWalletFeature
let TESTGenerateNewWalletFeature = declare(.testTarget(
	name: "GenerateNewWalletFeatureTests",
	dependencies: [GenerateNewWalletFeature].asDependencies
))

// MARK: - HoverPromptTextField
let HoverPromptTextField = declare(.target(
	name: "HoverPromptTextField",
	dependencies: [
		"Styleguide",
	]
))

// MARK: - InputField
let InputField = declare(.target(
	name: "InputField",
	dependencies: [
		"HoverPromptTextField",
		"PasswordValidator",
		"Styleguide",
	]
))

// MARK: - KeychainClient
let KeychainClient = declare(.target(
	name: "KeychainClient",
	dependencies: [
		"Common",
		"WrappedKeychain",
		"PINCode",
		"Wallet",
		Zesame_ALREADY_DEPENDENCY_FIX_ME, // ZilAmount (cached balance)
	]
))

// MARK: - WrappedKeychain
let WrappedKeychain = declare(.target(
	name: "WrappedKeychain",
	dependencies: [
		"KeychainAccess",
		"Wallet",
	]
))

// MARK: - MainFeature
let MainFeature = declare(.target(
	name: "MainFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"PINCode",
		"TabsFeature",
		"UnlockAppFeature",
		"Wallet",
	]
))

// MARK: - NewPINFeature
let NewPINFeature = declare(.target(
	name: "NewPINFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"PINField",
		"Styleguide",
		"Screen",
	]
))

// MARK: - NewWalletFeature
let NewWalletFeature = declare(.target(
	name: "NewWalletFeature",
	dependencies: [
		"BackUpWalletFeature",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"EnsurePrivacyFeature",
		"GenerateNewWalletFeature",
		"KeychainClient",
		"PasswordValidator",
		"WalletGenerator",
	]
))

// MARK: - NewWalletOrRestoreFeature
let NewWalletOrRestoreFeature = declare(.target(
	name: "NewWalletOrRestoreFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Styleguide",
		"Screen",
	]
))

// MARK: - OnboardingFeature
let OnboardingFeature = declare(.target(
	name: "OnboardingFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"NewPINFeature",
		"PasswordValidator",
		"SetupWalletFeature",
		"TermsOfServiceFeature",
		"UserDefaultsClient",
		"WelcomeFeature",
		"WalletGenerator",
	]
))

// MARK: - PasswordInputFields
let PasswordInputFields = declare(.target(
	name: "PasswordInputFields",
	dependencies: [
		"InputField",
		"HoverPromptTextField",
	]
))

// MARK: - PasswordValidator
let PasswordValidator = declare(.target(
	name: "PasswordValidator",
	dependencies: [
		"Common",
	]
))

// MARK: - PINCode
let PINCode = declare(.target(
	name: "PINCode",
	dependencies: []
))

// MARK: - TEST PINCode
let TESTPINCode = declare(.testTarget(
	name: "PINCodeTests",
	dependencies: [PINCode].asDependencies
))

// MARK: - PINField
let PINField = declare(.target(
	name: "PINField",
	dependencies: [
		"HoverPromptTextField",
		"PINCode",
		"Styleguide",
	]
))

// MARK: - Purger
let Purger = declare(.target(
	name: "Purger",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"UserDefaultsClient",
		"KeychainClient",
	]
))

// MARK: - ReceiveFeature
let ReceiveFeature = declare(.target(
	name: "ReceiveFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Screen",
		"Styleguide",
		"Wallet",
	]
))

// MARK: - RestoreWalletFeature
let RestoreWalletFeature = declare(.target(
	name: "RestoreWalletFeature",
	dependencies: [
		"Common",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"EnsurePrivacyFeature",
		"InputField",
		"PasswordValidator",
		"Screen",
		"Styleguide",
		"Wallet",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - QRCoding
let QRCoding = declare(.target(
	name: "QRCoding",
	dependencies: [
		"EFQRCode",
		"Styleguide",
		"TransactionIntent",
		"Wallet",
	]
))

// MARK: - Screen
let Screen = declare(.target(
	name: "Screen",
	dependencies: [
		"Styleguide",
	]
))

// MARK: - SettingsFeature
let SettingsFeature = declare(.target(
	name: "SettingsFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Purger",
		"Screen",
		"Styleguide",
		"TermsOfServiceFeature",
		"VersionFeature",
		"Wallet",
	]
))
// MARK: - TEST SettingsFeature
let TESTSettingsFeature = declare(.testTarget(
	name: "SettingsFeatureTests",
	dependencies: [SettingsFeature].asDependencies
))

// MARK: - SetupWalletFeature
let SetupWalletFeature = declare(.target(
	name: "SetupWalletFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"NewWalletOrRestoreFeature",
		"NewWalletFeature",
		"PasswordValidator",
		"RestoreWalletFeature",
		"Screen",
		"Styleguide",
		"Wallet",
		"WalletGenerator",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - SplashFeature
let SplashFeature = declare(.target(
	name: "SplashFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Purger",
		"Screen",
		"Styleguide",
		"UserDefaultsClient",
		"Wallet",
	]
))
// MARK: - TEST SplashFeature
let TESTSplashFeature	= declare(.testTarget(
	name: "SplashFeatureTests",
	dependencies: [SplashFeature].asDependencies
))

// MARK: - Styleguide
let Styleguide = declare(.target(
	name: "Styleguide",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - TabsFeature
let TabsFeature = declare(.target(
	name: "TabsFeature",
	dependencies: [
		"BalancesFeature",
		"ContactsFeature",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"ReceiveFeature",
		"SettingsFeature",
		"Styleguide",
		"TransferFeature",
		"UserDefaultsClient",
		"Wallet",
	]
))

// MARK: - TransactionIntent
let TransactionIntent = declare(.target(
	name: "TransactionIntent",
	dependencies: [
		Zesame_ALREADY_DEPENDENCY_FIX_ME
	]
))

// MARK: - TransferFeature
let TransferFeature = declare(.target(
	name: "TransferFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"Screen",
		"Styleguide",
		"Wallet",
	]
))

// MARK: - TermsOfServiceFeature
let TermsOfServiceFeature = declare(.target(
	name: "TermsOfServiceFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"UserDefaultsClient",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	],
	resources: [
		.process("Resources/")
	]
))
// MARK: - TEST TermsOfServiceFeature
let TESTTermsOfServiceFeature = declare(.testTarget(
	name: "TermsOfServiceFeatureTests",
	dependencies: [TermsOfServiceFeature].asDependencies
))


// MARK: - UnlockAppFeature
let UnlockAppFeature = declare(.target(
	name: "UnlockAppFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"KeychainClient",
		"PINCode",
		"PINField",
		"Screen",
		"Styleguide",
	]
))

// MARK: - UserDefaultsClient
let UserDefaultsClient = declare(.target(
	name: "UserDefaultsClient",
	dependencies: [
		"Common",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - VersionFeature
let VersionFeature = declare(.target(
	name: "VersionFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - Wallet
let Wallet = declare(.target(
	name: "Wallet",
	dependencies: [
		"Common",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
		"ZilliqaAPIEndpoint",
	]
))

// MARK: - WalletGenerator
let WalletGenerator = declare(.target(
	name: "WalletGenerator",
	dependencies: [
		"Common",
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Wallet",
	]
))

// MARK: - WalletGeneratorLive
let WalletGeneratorLive = declare(.target(
	name: "WalletGeneratorLive",
	dependencies: [
		"WalletGenerator",
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

// MARK: - WalletGeneratorUnsafeFast
let WalletGeneratorUnsafeFast = declare(.target(
	name: "WalletGeneratorUnsafeFast",
	dependencies: [
		"WalletGenerator",
		Zesame_ALREADY_DEPENDENCY_FIX_ME
	]
))

// MARK: - WelcomeFeature
let WelcomeFeature = declare(.target(
	name: "WelcomeFeature",
	dependencies: [
		ComposableArchitecture_ALREADY_DEPENDENCY_FIX_ME,
		"Screen",
		"Styleguide",
	]
))

// MARK: - ZilliqaAPIEndpoint
let ZilliqaAPIEndpoint = declare(.target(
	name: "ZilliqaAPIEndpoint",
	dependencies: [
		Zesame_ALREADY_DEPENDENCY_FIX_ME,
	]
))

let package = Package(
	name: "Zhip",
	platforms: [.macOS(.v12), .iOS(.v15)],
	products: products,
	dependencies: dependencies.packageDependencies,
	targets: targets
)
