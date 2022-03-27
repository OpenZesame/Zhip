// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct ExternalDependency {
	enum Category {
		case essential
		case architecture
		case navigation
		case view
		case `convenience`
	}
	let category: Category
	let packageDependency: Package.Dependency
	let targetDependency: Target.Dependency
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
		package packageDependency: Package.Dependency,
		target targetDependency: Target.Dependency,
		rationale: String,
		alternatives: [Alternative] = []
	) {
		self.category = category
		self.packageDependency = packageDependency
		self.targetDependency = targetDependency
		self.rationale = rationale
		self.alternatives = alternatives
	}
}
extension Array where Element == ExternalDependency {
	var packageDependencies: [Package.Dependency] { map { $0.packageDependency } }
	var targetDependencies: [Target.Dependency] { map { $0.targetDependency } }
}

private let Zesame: ExternalDependency = .init(
	category: .essential,
	// branch: structured_concurrency
	package: .package(url: "https://github.com/OpenZesame/Zesame.git", revision: "8918ddb06807724383ad2965461fffeea91f89af"),
	target: .product(name: "Zesame", package: "Zesame"),
	rationale: "Zilliqa Swift SDK, containing all account logic."
)

private let ComposableArchitecture: ExternalDependency = .init(
	category: .architecture,
	package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", revision: "d924b9ad27d2a2ccb0ada2639f5255084ff63382"), // later than 0.33.1, fixes WithViewStore bugs, see: https://github.com/pointfreeco/swift-composable-architecture/issues/1022 and PR https://github.com/pointfreeco/swift-composable-architecture/pull/1015
	target: .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
	rationale: "Testable, modular, scalable architecture gaining grounds as the go-to architecture for SwiftUI."
)

private let KeychainAccess: ExternalDependency = .init(
	category: .convenience,
	package: .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
	target: "KeychainAccess",
	rationale: "Keychain is very low level"
)

private let EFQRCode: ExternalDependency = .init(
	category: .view,
	package: .package(url: "https://github.com/EFPrefix/EFQRCode.git", from: "6.2.0"),
	target: "EFQRCode",
	rationale: "Convenient QR code generator supporting macOS and iOS."
)

//private let CodeScanner: ExternalDependency = .init(
//	category: .view,
//	package: .package(url: "https://github.com/Sajjon/CodeScanner.git", branch: "main"),
//	target: .product(name: "CodeScanner", package: "CodeScanner"),
//	rationale: "Convenient QR code scanning view."
//)

private let externalDependencies: [ExternalDependency] = [
	Zesame,
	ComposableArchitecture,
	KeychainAccess,
	EFQRCode,
//	CodeScanner,
]

// MARK: - Products (Libraries)
var products: [Product] = []
var targets: [Target] = []

struct InternalDependency {
	let name: String
	let isTest: Bool
	
	var asTargetDependency: Target.Dependency {
		// Same as: `.byNameItem(name: name, condition: nil)`
		Target.Dependency(stringLiteral: name)
	}
	init(target: Target) {
		self.name = target.name
		self.isTest = target.isTest
	}
}

func declare(_ target: Target) -> InternalDependency {
	targets.append(target)
	
	if !target.isTest {
		products.append(
			Product.library(name: target.name, targets: [target.name])
		)
	}
	return InternalDependency(target: target)
}



extension Array where Element == InternalDependency {
	var asTargetDependencies: [Target.Dependency] {
		map { $0.asTargetDependency }
	}
}

extension Target {
	static func testTarget(
		name: String,
		testing targetUnderTest: InternalDependency
	) -> Target {
		precondition(!targetUnderTest.isTest)
		return .testTarget(name: name, dependencies: [targetUnderTest].asTargetDependencies)
	}
	static func target(
		name: String,
		externalDependencies externalDependencyDeclarations: [ExternalDependency] = [],
		internalDependencies internalTargetDeclerations: [InternalDependency] = [],
		path: String? = nil,
		exclude: [String] = [],
		sources: [String]? = nil,
		resources: [Resource]? = nil,
		publicHeadersPath: String? = nil,
		cSettings: [CSetting]? = nil,
		cxxSettings: [CXXSetting]? = nil,
		swiftSettings: [SwiftSetting]? = nil,
		linkerSettings: [LinkerSetting]? = nil,
		plugins: [Target.PluginUsage]? = nil
	) -> Target {
		
		let externalDependencies: [Target.Dependency] = externalDependencyDeclarations.map { $0.targetDependency }
		let internalDependecyNames = Set<String>(internalTargetDeclerations.map { $0.name })
		let internalDependencies: [Target.Dependency] = internalDependecyNames.map {
			Target.Dependency(stringLiteral: $0)
		}
		
		return .target(
			name: name,
			dependencies: externalDependencies + internalDependencies,
			path: path,
			exclude: exclude,
			sources: sources,
			resources: resources,
			publicHeadersPath: publicHeadersPath,
			cSettings: cSettings,
			cxxSettings: cxxSettings,
			swiftSettings: swiftSettings,
			linkerSettings: linkerSettings,
			plugins: plugins
		)
	}
}

// MARK: - PINCode
let PINCode = declare(.target(
	name: "PINCode",
	internalDependencies: []
))

// MARK: - Styleguide
let Styleguide = declare(.target(
	name: "Styleguide",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: []
))

// MARK: - Screen
let Screen = declare(.target(
	name: "Screen",
	internalDependencies: [
		Styleguide,
	]
))

// MARK: - Common
let Common = declare(.target(
	name: "Common",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: []
))

// MARK: - ZilliqaAPIEndpoint
let ZilliqaAPIEndpoint = declare(.target(
	name: "ZilliqaAPIEndpoint",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: []
))

// MARK: - HoverPromptTextField
let HoverPromptTextField = declare(.target(
	name: "HoverPromptTextField",
	internalDependencies: [
		Styleguide,
	]
))

// MARK: - Checkbox
let Checkbox = declare(.target(
	name: "Checkbox",
	internalDependencies: [
		Styleguide,
	]
))

// MARK: - Wallet
let Wallet = declare(.target(
	name: "Wallet",
	externalDependencies: [
		ComposableArchitecture,
		Zesame,
	],
	internalDependencies: [
		Common,
		ZilliqaAPIEndpoint
	]
))

// MARK: - WrappedKeychain
let WrappedKeychain = declare(.target(
	name: "WrappedKeychain",
	externalDependencies: [
		KeychainAccess,
	],
	internalDependencies: [
		Wallet,
	]
))

// MARK: - UserDefaultsClient
let UserDefaultsClient = declare(.target(
	name: "UserDefaultsClient",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Common,
	]
))

// MARK: - KeychainClient
let KeychainClient = declare(.target(
	name: "KeychainClient",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: [
		Common,
		WrappedKeychain,
		PINCode,
		Wallet,
	]
))

// MARK: - Purger
let Purger = declare(.target(
	name: "Purger",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		UserDefaultsClient,
		KeychainClient,
	]
))

// MARK: - VersionFeature
let VersionFeature = declare(.target(
	name: "VersionFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Common,
	]
))

// MARK: - PasswordValidator
let PasswordValidator = declare(.target(
	name: "PasswordValidator",
	internalDependencies: [
		Common,
	]
))

// MARK: - TEST PINCode
let TESTPINCode = declare(.testTarget(
	name: "PINCodeTests",
	testing: PINCode
))

// MARK: - AmountFormatter
let AmountFormatter = declare(.target(
	name: "AmountFormatter",
	externalDependencies: [
		Zesame
	],
	internalDependencies: [
		Common
	]
))

// MARK: - InputField
let InputField = declare(.target(
	name: "InputField",
	internalDependencies: [
		HoverPromptTextField,
		PasswordValidator,
		Styleguide,
	]
))

// MARK: - PasswordInputFields
let PasswordInputFields = declare(.target(
	name: "PasswordInputFields",
	internalDependencies: [
		InputField,
		HoverPromptTextField,
	]
))

// MARK: - BackUpKeystoreFeature
let BackUpKeystoreFeature = declare(.target(
	name: "BackUpKeystoreFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Screen,
		Styleguide,
	]
))

// MARK: - EnsurePrivacyFeature
let EnsurePrivacyFeature = declare(.target(
	name: "EnsurePrivacyFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Screen,
		Styleguide,
	]
))

// MARK: - BackUpRevealedKeyPairFeature
let BackUpRevealedKeyPairFeature = declare(.target(
	name: "BackUpRevealedKeyPairFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Screen,
		Styleguide,
	]
))

// MARK: - NewWalletOrRestoreFeature
let NewWalletOrRestoreFeature = declare(.target(
	name: "NewWalletOrRestoreFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Styleguide,
		Screen,
	]
))

// MARK: - DecryptKeystoreFeature
let DecryptKeystoreFeature = declare(.target(
	name: "DecryptKeystoreFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		InputField,
		Screen,
		Styleguide,
	]
))

// MARK: - BackUpPrivateKeyFeature
let BackUpPrivateKeyFeature = declare(.target(
	name: "BackUpPrivateKeyFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		DecryptKeystoreFeature,
		BackUpRevealedKeyPairFeature,
	]
))

// MARK: - BackUpPrivateKeyAndKeystoreFeature
let BackUpPrivateKeyAndKeystoreFeature = declare(.target(
	name: "BackUpPrivateKeyAndKeystoreFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		BackUpKeystoreFeature,
		BackUpPrivateKeyFeature,
		Checkbox,
		Screen,
		Styleguide,
	]
))

// MARK: - BackUpWalletFeature
let BackUpWalletFeature = declare(.target(
	name: "BackUpWalletFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		BackUpPrivateKeyAndKeystoreFeature,
		Checkbox,
		InputField,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - WalletGenerator
let WalletGenerator = declare(.target(
	name: "WalletGenerator",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Common,
		Wallet,
	]
))

// MARK: - WalletGeneratorLive
let WalletGeneratorLive = declare(.target(
	name: "WalletGeneratorLive",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: [
		WalletGenerator,
	]
))

// MARK: - WalletGeneratorUnsafeFast
let WalletGeneratorUnsafeFast = declare(.target(
	name: "WalletGeneratorUnsafeFast",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: [
		WalletGenerator,
	]
))

// MARK: - BalancesFeature
let BalancesFeature = declare(.target(
	name: "BalancesFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - ContactsFeature
let ContactsFeature = declare(.target(
	name: "ContactsFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - GenerateNewWalletFeature
let GenerateNewWalletFeature = declare(.target(
	name: "GenerateNewWalletFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Checkbox,
		HoverPromptTextField,
		InputField,
		KeychainClient,
		PasswordInputFields,
		PasswordValidator,
		Screen,
		Styleguide,
		Wallet,
		WalletGenerator,
	]
))
// MARK: - TEST GenerateNewWalletFeature
let TESTGenerateNewWalletFeature = declare(.testTarget(
	name: "GenerateNewWalletFeatureTests",
	testing: GenerateNewWalletFeature
))

// MARK: - ReceiveFeature
let ReceiveFeature = declare(.target(
	name: "ReceiveFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - TermsOfServiceFeature
let TermsOfServiceFeature = declare(.target(
	name: "TermsOfServiceFeature",
	externalDependencies: [
		ComposableArchitecture,
		Zesame,
	],
	internalDependencies: [
		Screen,
		UserDefaultsClient,
	],
	resources: [
		.process("Resources/")
	]
))
// MARK: - TEST TermsOfServiceFeature
let TESTTermsOfServiceFeature = declare(.testTarget(
	name: "TermsOfServiceFeatureTests",
	testing: TermsOfServiceFeature
))

// MARK: - SettingsFeature
let SettingsFeature = declare(.target(
	name: "SettingsFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Purger,
		Screen,
		Styleguide,
		TermsOfServiceFeature,
		VersionFeature,
		Wallet,
	]
))
// MARK: - TEST SettingsFeature
let TESTSettingsFeature = declare(.testTarget(
	name: "SettingsFeatureTests",
	testing: SettingsFeature
))

// MARK: - TransferFeature
let TransferFeature = declare(.target(
	name: "TransferFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - TabsFeature
let TabsFeature = declare(.target(
	name: "TabsFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		BalancesFeature,
		ContactsFeature,
		KeychainClient,
		ReceiveFeature,
		SettingsFeature,
		Styleguide,
		TransferFeature,
		UserDefaultsClient,
		Wallet,
	]
))

// MARK: - PINField
let PINField = declare(.target(
	name: "PINField",
	internalDependencies: [
		HoverPromptTextField,
		PINCode,
		Styleguide,
	]
))

// MARK: - UnlockAppFeature
let UnlockAppFeature = declare(.target(
	name: "UnlockAppFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		PINCode,
		PINField,
		Screen,
		Styleguide,
	]
))

// MARK: - MainFeature
let MainFeature = declare(.target(
	name: "MainFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		PINCode,
		TabsFeature,
		UnlockAppFeature,
		Wallet,
	]
))

// MARK: - NewPINFeature
let NewPINFeature = declare(.target(
	name: "NewPINFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Checkbox,
		KeychainClient,
		PINField,
		Styleguide,
		Screen,
	]
))

// MARK: - NewWalletFeature
let NewWalletFeature = declare(.target(
	name: "NewWalletFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		BackUpWalletFeature,
		EnsurePrivacyFeature,
		GenerateNewWalletFeature,
		KeychainClient,
		PasswordValidator,
		WalletGenerator,
	]
))

// MARK: - RestoreWalletFeature
let RestoreWalletFeature = declare(.target(
	name: "RestoreWalletFeature",
	externalDependencies: [
		ComposableArchitecture,
		Zesame,
	],
	internalDependencies: [
		Common,
		EnsurePrivacyFeature,
		InputField,
		PasswordValidator,
		Screen,
		Styleguide,
		Wallet,
	]
))

// MARK: - SetupWalletFeature
let SetupWalletFeature = declare(.target(
	name: "SetupWalletFeature",
	externalDependencies: [
		ComposableArchitecture,
		Zesame,
	],
	internalDependencies: [
		KeychainClient,
		NewWalletOrRestoreFeature,
		NewWalletFeature,
		PasswordValidator,
		RestoreWalletFeature,
		Screen,
		Styleguide,
		Wallet,
		WalletGenerator,
	]
))

// MARK: - WelcomeFeature
let WelcomeFeature = declare(.target(
	name: "WelcomeFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		Screen,
		Styleguide,
	]
))

// MARK: - OnboardingFeature
let OnboardingFeature = declare(.target(
	name: "OnboardingFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		NewPINFeature,
		PasswordValidator,
		SetupWalletFeature,
		TermsOfServiceFeature,
		UserDefaultsClient,
		WelcomeFeature,
		WalletGenerator,
	]
))

// MARK: - TransactionIntent
let TransactionIntent = declare(.target(
	name: "TransactionIntent",
	externalDependencies: [
		Zesame,
	],
	internalDependencies: []
))

// MARK: - QRCoding
let QRCoding = declare(.target(
	name: "QRCoding",
	externalDependencies: [
		EFQRCode,
	],
	internalDependencies: [
		Styleguide,
		TransactionIntent,
		Wallet,
	]
))

// MARK: - SplashFeature
let SplashFeature = declare(.target(
	name: "SplashFeature",
	externalDependencies: [
		ComposableArchitecture,
	],
	internalDependencies: [
		KeychainClient,
		Purger,
		Screen,
		Styleguide,
		UserDefaultsClient,
		Wallet,
	]
))
// MARK: - TEST SplashFeature
let TESTSplashFeature	= declare(.testTarget(
	name: "SplashFeatureTests",
	testing: SplashFeature
))

// MARK: - AppFeature
let Appfeature = declare(.target(
	name: "AppFeature",
	externalDependencies: [
		ComposableArchitecture,
		Zesame,
	],
	internalDependencies: [
		Common,
		KeychainClient,
		MainFeature,
		OnboardingFeature,
		PasswordValidator,
		Styleguide,
		SplashFeature,
		UserDefaultsClient,
		WalletGeneratorLive,
	]
))
// MARK: - TEST AppFeature
let TESTAppFeatures	= declare(.testTarget(
	name: "AppFeatureTests",
	testing: Appfeature
))

let package = Package(
	name: "Zhip",
	platforms: [.macOS(.v12), .iOS(.v15)],
	products: products,
	dependencies: externalDependencies.packageDependencies,
	targets: targets
)
