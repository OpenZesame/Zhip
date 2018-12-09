// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Error {
    internal enum Input {
      internal enum Address {
        /// Only 0-9 and A-F allowed
        internal static let containsNonHexadecimal = L10n.tr("Localizable", "Error.Input.Address.ContainsNonHexadecimal")
        /// Address is too long, should be %d
        internal static func tooLong(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.Address.TooLong", p1)
        }
        /// Address is too short, should be %d
        internal static func tooShort(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.Address.TooShort", p1)
        }
      }
      internal enum Amount {
        /// Amount must be smaller than %@
        internal static func tooLarge(_ p1: String) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooLarge", p1)
        }
        /// Amount must be greater than %@
        internal static func tooSmall(_ p1: String) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooSmall", p1)
        }
      }
      internal enum Passphrase {
        /// Passphrase have length >%d
        internal static func tooShort(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.Passphrase.TooShort", p1)
        }
      }
    }
  }

  internal enum Generic {
    /// Back
    internal static let back = L10n.tr("Localizable", "Generic.Back")
    /// Close
    internal static let close = L10n.tr("Localizable", "Generic.Close")
    /// Next
    internal static let next = L10n.tr("Localizable", "Generic.Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Generic.OK")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "Generic.Skip")
  }

  internal enum Scene {
    internal enum AskForAnalyticsPermissions {
      /// Analytics disclaimer
      internal static let title = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Title")
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Button.Accept")
        /// Decline
        internal static let decline = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Button.Decline")
      }
      internal enum Checkbox {
        /// I have read the analytics disclaimer
        internal static let readDisclaimer = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Checkbox.ReadDisclaimer")
      }
      internal enum Text {
        /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        internal static let disclaimer = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Text.Disclaimer")
      }
    }
    internal enum BackUpRevealedKeyPair {
      /// Backup key pair
      internal static let title = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Title")
      internal enum Button {
        /// Copy private key
        internal static let copyPrivateKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Button.CopyPrivateKey")
        /// Copy public key
        internal static let copyPublicKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Button.CopyPublicKey")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied private key
          internal static let didCopyPrivateKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Event.Toast.DidCopyPrivateKey")
          /// Copied public key
          internal static let didCopyPublicKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Event.Toast.DidCopyPublicKey")
        }
      }
      internal enum Label {
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Label.PrivateKey")
        /// Uncompressed public key
        internal static let uncompressedPublicKey = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Label.UncompressedPublicKey")
      }
    }
    internal enum BackupWallet {
      /// Backup Wallet
      internal static let title = L10n.tr("Localizable", "Scene.BackupWallet.Title")
      internal enum Button {
        /// Copy keystore
        internal static let copyKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Button.CopyKeystore")
        /// I've backed up, proceed
        internal static let haveBackedUpProceed = L10n.tr("Localizable", "Scene.BackupWallet.Button.HaveBackedUpProceed")
        /// Reveal keystore
        internal static let revealKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Button.RevealKeystore")
        /// Reveal private key
        internal static let revealPrivateKey = L10n.tr("Localizable", "Scene.BackupWallet.Button.RevealPrivateKey")
      }
      internal enum Checkbox {
        /// Keystore is backed up
        internal static let keystoreIsBackedUp = L10n.tr("Localizable", "Scene.BackupWallet.Checkbox.KeystoreIsBackedUp")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied keystore
          internal static let didCopyKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Event.Toast.DidCopyKeystore")
        }
      }
      internal enum Label {
        /// Store the keystore + passphrase somewhere safe (e.g. 1Password)
        internal static let storeKeystoreSecurely = L10n.tr("Localizable", "Scene.BackupWallet.Label.StoreKeystoreSecurely")
        /// ⚠️ I understand that I'm responsible for securely backing up the keystore and might suffer permanent loss of all assets if I fail to do so.
        internal static let urgeSecureBackupOfKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Label.UrgeSecureBackupOfKeystore")
      }
    }
    internal enum ChoosePincode {
      /// Set app PIN
      internal static let title = L10n.tr("Localizable", "Scene.ChoosePincode.Title")
      internal enum Button {
        /// Proceed
        internal static let proceedWithConfirmation = L10n.tr("Localizable", "Scene.ChoosePincode.Button.ProceedWithConfirmation")
      }
      internal enum Text {
        /// This pincode is optional and is only used to lock this app when you close it, its purpose is to protect against unwanted users to access the app. This pincode has nothing to do with the cryptography related to you wallet. However, if you have not backed up your wallet and forget this pincode you will be locked out of this app and thus your wallet
        internal static let pincodeOnlyLocksApp = L10n.tr("Localizable", "Scene.ChoosePincode.Text.PincodeOnlyLocksApp")
      }
    }
    internal enum ChooseWallet {
      /// Add Wallet
      internal static let title = L10n.tr("Localizable", "Scene.ChooseWallet.Title")
      internal enum Button {
        /// New Wallet
        internal static let newWallet = L10n.tr("Localizable", "Scene.ChooseWallet.Button.NewWallet")
        /// Restore Wallet
        internal static let restoreWallet = L10n.tr("Localizable", "Scene.ChooseWallet.Button.RestoreWallet")
      }
    }
    internal enum ConfirmNewPincode {
      /// Confirm app PIN
      internal static let title = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Title")
      internal enum Button {
        /// Confirm
        internal static let confirmPincode = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Button.ConfirmPincode")
      }
      internal enum Checkbox {
        /// I've backed up my PIN code
        internal static let pincodeIsBackedUp = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Checkbox.PincodeIsBackedUp")
      }
    }
    internal enum CreateNewWallet {
      /// New wallet
      internal static let title = L10n.tr("Localizable", "Scene.CreateNewWallet.Title")
      internal enum Button {
        /// Create new wallet
        internal static let createNewWallet = L10n.tr("Localizable", "Scene.CreateNewWallet.Button.CreateNewWallet")
      }
      internal enum Checkbox {
        /// Passphrase is backed up
        internal static let passphraseIsBackedUp = L10n.tr("Localizable", "Scene.CreateNewWallet.Checkbox.PassphraseIsBackedUp")
      }
      internal enum Field {
        /// Confirm encryption passphrase
        internal static let confirmEncryptionPassphrase = L10n.tr("Localizable", "Scene.CreateNewWallet.Field.ConfirmEncryptionPassphrase")
        /// Encryption passphrase (min %d chars)
        internal static func encryptionPassphrase(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Scene.CreateNewWallet.Field.EncryptionPassphrase", p1)
        }
      }
      internal enum Label {
        /// Choose new passphrase
        internal static let chooseNewPassphrase = L10n.tr("Localizable", "Scene.CreateNewWallet.Label.ChooseNewPassphrase")
        /// ⚠️ I understand that I'm responsible for securely backing up the encryption passphrase and might suffer permanent loss of all assets if I fail to do so.
        internal static let urgeBackup = L10n.tr("Localizable", "Scene.CreateNewWallet.Label.UrgeBackup")
      }
    }
    internal enum DecryptKeystoreToRevealKeyPair {
      /// Decrypt keystore
      internal static let title = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Title")
      internal enum Button {
        /// Reveal
        internal static let reveal = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Button.Reveal")
      }
      internal enum Field {
        /// Encryption passphrase (min %d chars)
        internal static func encryptionPassphrase(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Field.EncryptionPassphrase", p1)
        }
      }
    }
    internal enum Main {
      internal enum Button {
        /// Receive
        internal static let receive = L10n.tr("Localizable", "Scene.Main.Button.Receive")
        /// Send
        internal static let send = L10n.tr("Localizable", "Scene.Main.Button.Send")
      }
      internal enum Label {
        internal enum Balance {
          /// Your balance
          internal static let title = L10n.tr("Localizable", "Scene.Main.Label.Balance.Title")
          /// %@ ZILs
          internal static func value(_ p1: String) -> String {
            return L10n.tr("Localizable", "Scene.Main.Label.Balance.Value", p1)
          }
        }
      }
    }
    internal enum PrepareTransaction {
      /// Send
      internal static let title = L10n.tr("Localizable", "Scene.PrepareTransaction.Title")
      internal enum Button {
        /// See transaction Info
        internal static let seeTransactionInfo = L10n.tr("Localizable", "Scene.PrepareTransaction.Button.SeeTransactionInfo")
        /// Send
        internal static let send = L10n.tr("Localizable", "Scene.PrepareTransaction.Button.Send")
      }
      internal enum Field {
        /// Amount
        internal static let amount = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Amount")
        /// Encryption passphrase
        internal static let encryptionPassphrase = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.EncryptionPassphrase")
        /// Gas limit
        internal static let gasLimit = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.GasLimit")
        /// Gas price
        internal static let gasPrice = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.GasPrice")
        /// To address
        internal static let recipient = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Recipient")
      }
      internal enum Label {
        /// Transaction Id
        internal static let transactionId = L10n.tr("Localizable", "Scene.PrepareTransaction.Label.TransactionId")
      }
      internal enum Labels {
        internal enum Balance {
          /// Current balance
          internal static let title = L10n.tr("Localizable", "Scene.PrepareTransaction.Labels.Balance.Title")
          /// %@ ZILs
          internal static func value(_ p1: String) -> String {
            return L10n.tr("Localizable", "Scene.PrepareTransaction.Labels.Balance.Value", p1)
          }
        }
      }
    }
    internal enum Receive {
      /// Receive
      internal static let title = L10n.tr("Localizable", "Scene.Receive.Title")
      internal enum Button {
        /// Copy address
        internal static let copyMyAddress = L10n.tr("Localizable", "Scene.Receive.Button.CopyMyAddress")
        /// Share address
        internal static let share = L10n.tr("Localizable", "Scene.Receive.Button.Share")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied address
          internal static let didCopyAddress = L10n.tr("Localizable", "Scene.Receive.Event.Toast.DidCopyAddress")
        }
      }
      internal enum Field {
        /// Amount
        internal static let amount = L10n.tr("Localizable", "Scene.Receive.Field.Amount")
      }
      internal enum Label {
        /// My public address
        internal static let myPublicAddress = L10n.tr("Localizable", "Scene.Receive.Label.MyPublicAddress")
      }
    }
    internal enum RemovePincode {
      /// Unlock to remove
      internal static let title = L10n.tr("Localizable", "Scene.RemovePincode.Title")
      internal enum Event {
        internal enum Toast {
          /// Pincode removed
          internal static let didRemovePincode = L10n.tr("Localizable", "Scene.RemovePincode.Event.Toast.DidRemovePincode")
        }
      }
    }
    internal enum RestoreWallet {
      /// Restore Wallet
      internal static let title = L10n.tr("Localizable", "Scene.RestoreWallet.Title")
      internal enum Button {
        /// Restore Wallet
        internal static let restoreWallet = L10n.tr("Localizable", "Scene.RestoreWallet.Button.RestoreWallet")
      }
      internal enum Field {
        /// Confirm encryption passphrase
        internal static let confirmEncryptionPassphrase = L10n.tr("Localizable", "Scene.RestoreWallet.Field.ConfirmEncryptionPassphrase")
        /// Encryption passphrase (min %d chars)
        internal static func encryptionPassphrase(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Scene.RestoreWallet.Field.EncryptionPassphrase", p1)
        }
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Field.PrivateKey")
      }
      internal enum Segment {
        /// Keystore
        internal static let keystore = L10n.tr("Localizable", "Scene.RestoreWallet.Segment.Keystore")
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Segment.PrivateKey")
      }
    }
    internal enum Settings {
      /// Settings
      internal static let title = L10n.tr("Localizable", "Scene.Settings.Title")
      internal enum Cell {
        /// Acknowledgements
        internal static let acknowledgements = L10n.tr("Localizable", "Scene.Settings.Cell.Acknowledgements")
        /// Version
        internal static let appVersion = L10n.tr("Localizable", "Scene.Settings.Cell.AppVersion")
        /// Backup wallet
        internal static let backupWallet = L10n.tr("Localizable", "Scene.Settings.Cell.BackupWallet")
        /// Read ERC-20 warning
        internal static let readERC20Warning = L10n.tr("Localizable", "Scene.Settings.Cell.ReadERC20Warning")
        /// Remove pincode
        internal static let removePincode = L10n.tr("Localizable", "Scene.Settings.Cell.RemovePincode")
        /// Remove wallet
        internal static let removeWallet = L10n.tr("Localizable", "Scene.Settings.Cell.RemoveWallet")
        /// Report issue on Github
        internal static let reportIssueOnGithub = L10n.tr("Localizable", "Scene.Settings.Cell.ReportIssueOnGithub")
        /// Set pincode
        internal static let setPincode = L10n.tr("Localizable", "Scene.Settings.Cell.SetPincode")
        /// Star us on Github
        internal static let starUsOnGithub = L10n.tr("Localizable", "Scene.Settings.Cell.StarUsOnGithub")
        /// Terms of service
        internal static let termsOfService = L10n.tr("Localizable", "Scene.Settings.Cell.Terms of service")
      }
    }
    internal enum SignTransaction {
      internal enum Button {
        /// Confirm
        internal static let confirm = L10n.tr("Localizable", "Scene.SignTransaction.Button.Confirm")
      }
      internal enum Field {
        /// Encryption passphrase
        internal static let encryptionPassphrase = L10n.tr("Localizable", "Scene.SignTransaction.Field.EncryptionPassphrase")
      }
      internal enum Label {
        /// Confirm transaction with your passphrase
        internal static let signTransactionWithEncryptionPassphrase = L10n.tr("Localizable", "Scene.SignTransaction.Label.SignTransactionWithEncryptionPassphrase")
      }
    }
    internal enum TermsOfService {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.TermsOfService.Button.Accept")
      }
    }
    internal enum UnlockAppWithPincode {
      /// Unlock app
      internal static let title = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Title")
    }
    internal enum WarningERC20 {
      /// ⚠️ WARNING ⚠️
      internal static let title = L10n.tr("Localizable", "Scene.WarningERC20.Title")
      internal enum Button {
        /// I understand
        internal static let accept = L10n.tr("Localizable", "Scene.WarningERC20.Button.Accept")
        /// Do not show this again
        internal static let doNotShowAgain = L10n.tr("Localizable", "Scene.WarningERC20.Button.DoNotShowAgain")
      }
      internal enum Text {
        /// This is a Zilliqa testnet. Please do not send any interim ERC-20 ZIL tokens to this wallet.\n\nZilliqa and the Ethereum blockchain are two completely separate platforms and the mneumonic phrases, private keys, addresses and tokens CANNOT be shared.\n\nTransferring assets directly from Ethereum to Zilliqa (or vice versa) will cause irreparable loss.
        internal static let warningERC20 = L10n.tr("Localizable", "Scene.WarningERC20.Text.WarningERC20")
      }
    }
  }

  internal enum View {
    internal enum PullToRefreshControl {
      /// Pull to refresh
      internal static let title = L10n.tr("Localizable", "View.PullToRefreshControl.Title")
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
