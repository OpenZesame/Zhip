// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Icons {
    internal enum Large {
      internal static let analytics = ImageAsset(name: "Icons/Large/Analytics")
      internal static let camera = ImageAsset(name: "Icons/Large/Camera")
      internal static let checkmark = ImageAsset(name: "Icons/Large/Checkmark")
      internal static let dome = ImageAsset(name: "Icons/Large/Dome")
      internal static let receive = ImageAsset(name: "Icons/Large/Receive")
      internal static let send = ImageAsset(name: "Icons/Large/Send")
      internal static let shield = ImageAsset(name: "Icons/Large/Shield")
      internal static let termsOfService = ImageAsset(name: "Icons/Large/TermsOfService")
      internal static let warning = ImageAsset(name: "Icons/Large/Warning")
    }
    internal enum Small {
      internal static let analytics = ImageAsset(name: "Icons/Small/Analytics")
      internal static let backUp = ImageAsset(name: "Icons/Small/BackUp")
      internal static let camera = ImageAsset(name: "Icons/Small/Camera")
      internal static let checkmark = ImageAsset(name: "Icons/Small/Checkmark")
      internal static let chevronLeft = ImageAsset(name: "Icons/Small/ChevronLeft")
      internal static let chevronRight = ImageAsset(name: "Icons/Small/ChevronRight")
      internal static let cup = ImageAsset(name: "Icons/Small/Cup")
      internal static let delete = ImageAsset(name: "Icons/Small/Delete")
      internal static let document = ImageAsset(name: "Icons/Small/Document")
      internal static let ecc = ImageAsset(name: "Icons/Small/ECC")
      internal static let githubIssue = ImageAsset(name: "Icons/Small/GithubIssue")
      internal static let githubStar = ImageAsset(name: "Icons/Small/GithubStar")
      internal static let pinCode = ImageAsset(name: "Icons/Small/PinCode")
      internal static let settings = ImageAsset(name: "Icons/Small/Settings")
      internal static let warning = ImageAsset(name: "Icons/Small/Warning")
      internal static let zilliqaLogo = ImageAsset(name: "Icons/Small/ZilliqaLogo")
    }
  }
  internal enum Images {
    internal enum ChooseWallet {
      internal static let backAbyss = ImageAsset(name: "Images/ChooseWallet/BackAbyss")
      internal static let frontPlanets = ImageAsset(name: "Images/ChooseWallet/FrontPlanets")
      internal static let middleStars = ImageAsset(name: "Images/ChooseWallet/MiddleStars")
    }
    internal enum Main {
      internal static let backAurora = ImageAsset(name: "Images/Main/BackAurora")
      internal static let frontAurora = ImageAsset(name: "Images/Main/FrontAurora")
      internal static let middleAurora = ImageAsset(name: "Images/Main/MiddleAurora")
    }
    internal enum Welcome {
      internal static let backClouds = ImageAsset(name: "Images/Welcome/BackClouds")
      internal static let frontBlastOff = ImageAsset(name: "Images/Welcome/FrontBlastOff")
      internal static let middleSpaceship = ImageAsset(name: "Images/Welcome/MiddleSpaceship")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
