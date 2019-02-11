// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

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

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
