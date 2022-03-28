// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var externalDependencies: [ExternalDependency] = []
var targets: [Target] = []

// MARK: - EXTERNAL DEPENDENCIES
// MARK: -

// MARK: - =====================
// MARK: - =====================
// MARK: - =====================
// MARK: - =====================
// MARK: - =====================


// MARK: - Zesame Ext.
let Zesame = externalDependency(
	category: .essential,
	// branch: structured_concurrency
	package: .package(url: "https://github.com/OpenZesame/Zesame.git", revision: "8918ddb06807724383ad2965461fffeea91f89af"),
	target: .product(name: "Zesame", package: "Zesame"),
	rationale: "Zilliqa Swift SDK, containing all account logic."
)

// MARK: - ComposableArchitecture Ext.
let ComposableArchitecture = externalDependency(
	category: .architecture,
	package: .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", revision: "d924b9ad27d2a2ccb0ada2639f5255084ff63382"), // later than 0.33.1, fixes WithViewStore bugs, see: https://github.com/pointfreeco/swift-composable-architecture/issues/1022 and PR https://github.com/pointfreeco/swift-composable-architecture/pull/1015
	target: .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
	rationale: "Testable, modular, scalable architecture gaining grounds as the go-to architecture for SwiftUI."
)

// MARK: - KeychainAccess Ext.
let KeychainAccess = externalDependency(
	category: .convenience,
	package: .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
	target: "KeychainAccess",
	rationale: "Keychain is very low level"
)

// MARK: - EFQRCode Ext.
let EFQRCode = externalDependency(
	category: .view,
	package: .package(url: "https://github.com/EFPrefix/EFQRCode.git", from: "6.2.0"),
	target: "EFQRCode",
	rationale: "Convenient QR code generator supporting macOS and iOS."
)

// MARK: - CodeScanner Ext.
let CodeScanner = externalDependency(
	category: .view,
	package: .package(url: "https://github.com/Sajjon/CodeScanner.git", branch: "main"),
	target: .product(name: "CodeScanner", package: "CodeScanner"),
	rationale: "Convenient QR code scanning view."
)



// MARK: - 🎯 TARGETS
// MARK: -

// MARK: - =====================
// MARK: - =====================
// MARK: - =====================
// MARK: - =====================
// MARK: - =====================
func makePackage() -> Package {
	
	// MARK: - PINCode (Tested)
	let PINCode = declareTarget(
		name: "PINCode",
		test: true,
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Styleguide
	let Styleguide = declareTarget(
		name: "Styleguide",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Screen
	let Screen = declareTarget(
		name: "Screen",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Common
	let Common = declareTarget(
		name: "Common",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - ZilliqaAPIEndpoint
	let ZilliqaAPIEndpoint = declareTarget(
		name: "ZilliqaAPIEndpoint",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - HoverPromptTextField
	let HoverPromptTextField = declareTarget(
		name: "HoverPromptTextField",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Checkbox
	let Checkbox = declareTarget(
		name: "Checkbox",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Wallet
	let Wallet = declareTarget(
		name: "Wallet",
		externalDependencies: [
			ComposableArchitecture,
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			ZilliqaAPIEndpoint,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - WrappedKeychain
	let WrappedKeychain = declareTarget(
		name: "WrappedKeychain",
		externalDependencies: [
			KeychainAccess,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - UserDefaultsClient
	let UserDefaultsClient = declareTarget(
		name: "UserDefaultsClient",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - KeychainClient
	let KeychainClient = declareTarget(
		name: "KeychainClient",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			WrappedKeychain,
			PINCode,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - Purger
	let Purger = declareTarget(
		name: "Purger",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			UserDefaultsClient,
			KeychainClient,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - VersionFeature
	let VersionFeature = declareTarget(
		name: "VersionFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - PasswordValidator
	let PasswordValidator = declareTarget(
		name: "PasswordValidator",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	
	// MARK: - AmountFormatter
	let AmountFormatter = declareTarget(
		name: "AmountFormatter",
		externalDependencies: [
			Zesame
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - InputField
	let InputField = declareTarget(
		name: "InputField",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			HoverPromptTextField,
			PasswordValidator,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - PasswordInputFields
	let PasswordInputFields = declareTarget(
		name: "PasswordInputFields",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			HoverPromptTextField,
			InputField,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BackUpKeystoreFeature
	let BackUpKeystoreFeature = declareTarget(
		name: "BackUpKeystoreFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - EnsurePrivacyFeature
	let EnsurePrivacyFeature = declareTarget(
		name: "EnsurePrivacyFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BackUpRevealedKeyPairFeature
	let BackUpRevealedKeyPairFeature = declareTarget(
		name: "BackUpRevealedKeyPairFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - NewWalletOrRestoreFeature
	let NewWalletOrRestoreFeature = declareTarget(
		name: "NewWalletOrRestoreFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Styleguide,
			Screen,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - DecryptKeystoreFeature
	let DecryptKeystoreFeature = declareTarget(
		name: "DecryptKeystoreFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			InputField,
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BackUpPrivateKeyFeature
	let BackUpPrivateKeyFeature = declareTarget(
		name: "BackUpPrivateKeyFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			BackUpRevealedKeyPairFeature,
			DecryptKeystoreFeature,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BackUpPrivateKeyAndKeystoreFeature
	let BackUpPrivateKeyAndKeystoreFeature = declareTarget(
		name: "BackUpPrivateKeyAndKeystoreFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			BackUpKeystoreFeature,
			BackUpPrivateKeyFeature,
			Checkbox,
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BackUpWalletFeature
	let BackUpWalletFeature = declareTarget(
		name: "BackUpWalletFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			BackUpPrivateKeyAndKeystoreFeature,
			Checkbox,
			InputField,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - WalletGenerator
	let WalletGenerator = declareTarget(
		name: "WalletGenerator",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - WalletGeneratorLive
	let WalletGeneratorLive = declareTarget(
		name: "WalletGeneratorLive",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			WalletGenerator,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - WalletGeneratorUnsafeFast
	let WalletGeneratorUnsafeFast = declareTarget(
		name: "WalletGeneratorUnsafeFast",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			WalletGenerator,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - BalancesFeature
	let BalancesFeature = declareTarget(
		name: "BalancesFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			AmountFormatter,
			KeychainClient,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - ContactsFeature
	let ContactsFeature = declareTarget(
		name: "ContactsFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - GenerateNewWalletFeature (Tested)
	let GenerateNewWalletFeature = declareTarget(
		name: "GenerateNewWalletFeature",
		test: true,
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
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
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - TransactionIntent
	let TransactionIntent = declareTarget(
		name: "TransactionIntent",
		externalDependencies: [
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - QRCoding
	let QRCoding = declareTarget(
		name: "QRCoding",
		externalDependencies: [
			EFQRCode,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Styleguide,
			TransactionIntent,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - ReceiveFeature
	let ReceiveFeature = declareTarget(
		name: "ReceiveFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			QRCoding,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - TermsOfServiceFeature (Tested)
	let TermsOfServiceFeature = declareTarget(
		name: "TermsOfServiceFeature",
		test: true,
		externalDependencies: [
			ComposableArchitecture,
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Screen,
			UserDefaultsClient,
			// ^^^ Sort alphabetically ^^^
		],
		resources: [
			.process("Resources/"),
		]
	)
	
	// MARK: - SettingsFeature (Tested)
	let SettingsFeature = declareTarget(
		name: "SettingsFeature",
		test: true,
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			Purger,
			Screen,
			Styleguide,
			TermsOfServiceFeature,
			VersionFeature,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - TransferFeature
	let TransferFeature = declareTarget(
		name: "TransferFeature",
		externalDependencies: [
			CodeScanner,
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - TabsFeature
	let TabsFeature = declareTarget(
		name: "TabsFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			BalancesFeature,
			ContactsFeature,
			KeychainClient,
			ReceiveFeature,
			SettingsFeature,
			Styleguide,
			TransferFeature,
			UserDefaultsClient,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - PINField
	let PINField = declareTarget(
		name: "PINField",
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			HoverPromptTextField,
			PINCode,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - UnlockAppFeature
	let UnlockAppFeature = declareTarget(
		name: "UnlockAppFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			PINCode,
			PINField,
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - MainFeature
	let MainFeature = declareTarget(
		name: "MainFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			PINCode,
			TabsFeature,
			UnlockAppFeature,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - NewPINFeature
	let NewPINFeature = declareTarget(
		name: "NewPINFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Checkbox,
			KeychainClient,
			PINField,
			Styleguide,
			Screen,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - NewWalletFeature
	let NewWalletFeature = declareTarget(
		name: "NewWalletFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			BackUpWalletFeature,
			EnsurePrivacyFeature,
			GenerateNewWalletFeature,
			KeychainClient,
			PasswordValidator,
			WalletGenerator,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - RestoreWalletFeature
	let RestoreWalletFeature = declareTarget(
		name: "RestoreWalletFeature",
		externalDependencies: [
			ComposableArchitecture,
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			EnsurePrivacyFeature,
			InputField,
			PasswordValidator,
			Screen,
			Styleguide,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - SetupWalletFeature
	let SetupWalletFeature = declareTarget(
		name: "SetupWalletFeature",
		externalDependencies: [
			ComposableArchitecture,
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			NewWalletOrRestoreFeature,
			NewWalletFeature,
			PasswordValidator,
			RestoreWalletFeature,
			Screen,
			Styleguide,
			Wallet,
			WalletGenerator,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - WelcomeFeature
	let WelcomeFeature = declareTarget(
		name: "WelcomeFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Screen,
			Styleguide,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - OnboardingFeature
	let OnboardingFeature = declareTarget(
		name: "OnboardingFeature",
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			NewPINFeature,
			PasswordValidator,
			SetupWalletFeature,
			TermsOfServiceFeature,
			UserDefaultsClient,
			WelcomeFeature,
			WalletGenerator,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - SplashFeature (Tested)
	let SplashFeature = declareTarget(
		name: "SplashFeature",
		test: true,
		externalDependencies: [
			ComposableArchitecture,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			KeychainClient,
			Purger,
			Screen,
			Styleguide,
			UserDefaultsClient,
			Wallet,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: - AppFeature (Tested)
	let _ = declareTarget(
		name: "AppFeature",
		test: true,
		externalDependencies: [
			ComposableArchitecture,
			Zesame,
		],
		internalDependencies: [
			// ˅˅˅ Sort alphabetically ˅˅˅
			Common,
			KeychainClient,
			MainFeature,
			OnboardingFeature,
			PasswordValidator,
			Styleguide,
			SplashFeature,
			UserDefaultsClient,
			WalletGeneratorLive,
			WalletGeneratorUnsafeFast,
			// ^^^ Sort alphabetically ^^^
		]
	)
	
	// MARK: Zhip Package
	return Package(
		name: "Zhip",
		platforms: [.macOS(.v12), .iOS(.v15)],
		products: targets.filter({ !$0.isTest }).map({ target in
			Product.library(name: target.name, targets: [target.name])
		}),
		dependencies: externalDependencies.map { $0.packageDependency },
		targets: targets
	)
	
}

// MARK: - ExternalDependency
// MARK: -
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

// MARK: - DECLARE EXTERNAL DEP.
func externalDependency(
	category: ExternalDependency.Category,
	package packageDependency: Package.Dependency,
	target targetDependency: Target.Dependency,
	rationale: String,
	alternatives: [ExternalDependency.Alternative] = []
) -> ExternalDependency {
	
	let externalDependency = ExternalDependency(
		category: category,
		package: packageDependency,
		target: targetDependency,
		rationale: rationale,
		alternatives: alternatives
	)
	externalDependencies.append(externalDependency)
	return externalDependency
}

// MARK: - InternalDependency
// MARK: -
typealias InternalDependency = String

// MARK: - DECLARE TARGET
func declareTarget(
	name: String,
	test declareMatchingTestTarget: Bool = false, // if test target is declared
	externalDependencies externalDependencyDeclarations: [ExternalDependency] = [],
	internalDependencies: [InternalDependency] = [],
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
) -> InternalDependency {
	
	let externalDependencies: [Target.Dependency] = externalDependencyDeclarations.map { $0.targetDependency }
	
	let internalDependencies: [Target.Dependency] = internalDependencies.map {
		Target.Dependency(stringLiteral: $0)
	}
	
	targets.append(
		Target.target(
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
	)
	
	if declareMatchingTestTarget {
		targets.append(
			Target.testTarget(
				name: "\(name)Tests",
				dependencies: [Target.Dependency.byNameItem(name: name, condition: nil)]
			)
		)
	}
	
	return name
}

let package = makePackage()
