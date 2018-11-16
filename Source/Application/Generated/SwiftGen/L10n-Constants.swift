// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Flow {
    internal enum Pincode {
      internal enum Event {
        internal enum Toast {
          /// Pincode removed
          internal static let didRemovePincode = L10n.tr("Localizable", "Flow.Pincode.Event.Toast.DidRemovePincode")
        }
      }
    }
  }

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
    /// Skip
    internal static let skip = L10n.tr("Localizable", "Generic.Skip")
  }

  internal enum Scene {
    internal enum BackupWallet {
      /// Backup Wallet
      internal static let title = L10n.tr("Localizable", "Scene.BackupWallet.Title")
      internal enum Button {
        /// Copy keystore
        internal static let copyKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Button.CopyKeystore")
        /// I've backed up, proceed
        internal static let haveBackedUpProceed = L10n.tr("Localizable", "Scene.BackupWallet.Button.HaveBackedUpProceed")
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
      internal enum SwitchLabel {
        /// Keystore is backed up
        internal static let keystoreIsBackedUp = L10n.tr("Localizable", "Scene.BackupWallet.SwitchLabel.KeystoreIsBackedUp")
      }
    }
    internal enum ChoosePincode {
      /// Choose pincode
      internal static let title = L10n.tr("Localizable", "Scene.ChoosePincode.Title")
      internal enum Button {
        /// Confirm Pincode
        internal static let confirmPincode = L10n.tr("Localizable", "Scene.ChoosePincode.Button.ConfirmPincode")
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
      /// Confirm pincode
      internal static let title = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Title")
      internal enum Button {
        /// Confirm Pincode
        internal static let confirmPincode = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Button.ConfirmPincode")
      }
    }
    internal enum CreateNewWallet {
      /// New wallet
      internal static let title = L10n.tr("Localizable", "Scene.CreateNewWallet.Title")
      internal enum Button {
        /// Create new wallet
        internal static let createNewWallet = L10n.tr("Localizable", "Scene.CreateNewWallet.Button.CreateNewWallet")
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
      internal enum SwitchLabel {
        /// Passphrase is backed up
        internal static let passphraseIsBackedUp = L10n.tr("Localizable", "Scene.CreateNewWallet.SwitchLabel.PassphraseIsBackedUp")
      }
    }
    internal enum Receive {
      /// Receive Zillings
      internal static let title = L10n.tr("Localizable", "Scene.Receive.Title")
      internal enum Button {
        /// Copy my address
        internal static let copyMyAddress = L10n.tr("Localizable", "Scene.Receive.Button.CopyMyAddress")
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
      internal enum Label {
        /// Or paste keystore (JSON) below
        internal static let orKeystore = L10n.tr("Localizable", "Scene.RestoreWallet.Label.OrKeystore")
      }
    }
    internal enum Send {
      /// Send Zillings
      internal static let title = L10n.tr("Localizable", "Scene.Send.Title")
      internal enum Button {
        /// See transaction Info
        internal static let seeTransactionInfo = L10n.tr("Localizable", "Scene.Send.Button.SeeTransactionInfo")
        /// Send
        internal static let send = L10n.tr("Localizable", "Scene.Send.Button.Send")
      }
      internal enum Field {
        /// Amount
        internal static let amount = L10n.tr("Localizable", "Scene.Send.Field.Amount")
        /// Encryption passphrase
        internal static let encryptionPassphrase = L10n.tr("Localizable", "Scene.Send.Field.EncryptionPassphrase")
        /// Gas limit
        internal static let gasLimit = L10n.tr("Localizable", "Scene.Send.Field.GasLimit")
        /// Gas price
        internal static let gasPrice = L10n.tr("Localizable", "Scene.Send.Field.GasPrice")
        /// To address
        internal static let recipient = L10n.tr("Localizable", "Scene.Send.Field.Recipient")
      }
      internal enum Label {
        /// %@ ZILs
        internal static func balance(_ p1: String) -> String {
          return L10n.tr("Localizable", "Scene.Send.Label.Balance", p1)
        }
        /// Transaction Id
        internal static let transactionId = L10n.tr("Localizable", "Scene.Send.Label.TransactionId")
      }
    }
    internal enum Settings {
      /// Settings
      internal static let title = L10n.tr("Localizable", "Scene.Settings.Title")
      internal enum Button {
        /// Backup wallet
        internal static let backupWallet = L10n.tr("Localizable", "Scene.Settings.Button.BackupWallet")
        /// Remove pincode
        internal static let removePincode = L10n.tr("Localizable", "Scene.Settings.Button.RemovePincode")
        /// Remove wallet
        internal static let removeWallet = L10n.tr("Localizable", "Scene.Settings.Button.RemoveWallet")
        /// Set pincode
        internal static let setPincode = L10n.tr("Localizable", "Scene.Settings.Button.SetPincode")
      }
      internal enum Label {
        /// App Version
        internal static let appVersion = L10n.tr("Localizable", "Scene.Settings.Label.AppVersion")
      }
    }
    internal enum TermsOfService {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.TermsOfService.Button.Accept")
      }
    }
    internal enum UnlockAppWithPincode {
      internal enum Title {
        /// Unlock to remove
        internal static let removePincode = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Title.RemovePincode")
        /// Unlock app
        internal static let resumeApp = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Title.ResumeApp")
      }
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
    internal enum Balance {
      internal enum Label {
        /// Balance
        internal static let balance = L10n.tr("Localizable", "View.Balance.Label.Balance")
        /// Current wallet nonce
        internal static let nonce = L10n.tr("Localizable", "View.Balance.Label.Nonce")
      }
    }
    internal enum PullToRefreshControl {
      /// Pull to refresh
      internal static let title = L10n.tr("Localizable", "View.PullToRefreshControl.Title")
    }
    internal enum Wallet {
      internal enum Label {
        /// Your Public Address
        internal static let yourAddress = L10n.tr("Localizable", "View.Wallet.Label.YourAddress")
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
