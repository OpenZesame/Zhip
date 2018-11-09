// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Generic {
    /// Back
    internal static let back = L10n.tr("Localizable", "Generic.Back")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Generic.Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "Generic.Close")
    /// Next
    internal static let next = L10n.tr("Localizable", "Generic.Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Generic.OK")
  }

  internal enum Scene {
    internal enum TermsOfService {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.TermsOfService.Button.Accept")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
