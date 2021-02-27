// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Error {
    internal enum Input {
      internal enum Address {
        /// Invalid checksum.
        internal static let addressNotChecksummed = L10n.tr("Localizable", "Error.Input.Address.AddressNotChecksummed")
        /// Invalid address
        internal static let invalid = L10n.tr("Localizable", "Error.Input.Address.Invalid")
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
        /// Insufficient funds
        internal static let exceedingBalance = L10n.tr("Localizable", "Error.Input.Amount.ExceedingBalance")
        /// String not a number
        internal static let nonNumericString = L10n.tr("Localizable", "Error.Input.Amount.NonNumericString")
        /// Must be at most %@
        internal static func tooLarge(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooLarge", String(describing: p1))
        }
        /// Must be at least %@
        internal static func tooSmall(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooSmall", String(describing: p1))
        }
      }
      internal enum Keystore {
        /// Bad JSON, control format.
        internal static let badFormatOrInput = L10n.tr("Localizable", "Error.Input.Keystore.BadFormatOrInput")
        /// Keystore was not encrypted by this password
        internal static let incorrectPassword = L10n.tr("Localizable", "Error.Input.Keystore.IncorrectPassword")
      }
      internal enum Password {
        /// Passwords does not match
        internal static let confirmingPasswordMismatch = L10n.tr("Localizable", "Error.Input.Password.ConfirmingPasswordMismatch")
        /// Incorrect password
        internal static let incorrectPassword = L10n.tr("Localizable", "Error.Input.Password.IncorrectPassword")
        /// Incorrect password, if you can't remember it do NOT continue, restart the wallet creation from the beginning.
        internal static let incorrectPasswordDuringBackupOfNewlyCreatedWallet = L10n.tr("Localizable", "Error.Input.Password.IncorrectPasswordDuringBackupOfNewlyCreatedWallet")
        /// Password have length >%d
        internal static func tooShort(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.Password.TooShort", p1)
        }
      }
      internal enum Pincode {
        /// Incorrect PIN
        internal static let incorrectPincode = L10n.tr("Localizable", "Error.Input.Pincode.IncorrectPincode")
        /// PIN does not match
        internal static let pincodesDoesNotMatch = L10n.tr("Localizable", "Error.Input.Pincode.PincodesDoesNotMatch")
      }
      internal enum PrivateKey {
        /// Bad private key
        internal static let badKey = L10n.tr("Localizable", "Error.Input.PrivateKey.BadKey")
        /// Should be %d characters (%d too many)
        internal static func tooLong(_ p1: Int, _ p2: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.PrivateKey.TooLong", p1, p2)
        }
        /// Should be %d characters (missing %d)
        internal static func tooShort(_ p1: Int, _ p2: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.PrivateKey.TooShort", p1, p2)
        }
      }
    }
  }

  internal enum Formatter {
    /// Fetching balance...
    internal static let balanceFirstFetch = L10n.tr("Localizable", "Formatter.BalanceFirstFetch")
    /// Balance last updated %@.
    internal static func balanceWasUpdatedAt(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Formatter.BalanceWasUpdatedAt", String(describing: p1))
    }
  }

  internal enum Generic {
    /// Back
    internal static let back = L10n.tr("Localizable", "Generic.Back")
    /// Close
    internal static let close = L10n.tr("Localizable", "Generic.Close")
    /// Hide
    internal static let hide = L10n.tr("Localizable", "Generic.Hide")
    /// Next
    internal static let next = L10n.tr("Localizable", "Generic.Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Generic.OK")
    /// Show
    internal static let show = L10n.tr("Localizable", "Generic.Show")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "Generic.Skip")
    /// ZILs
    internal static let zils = L10n.tr("Localizable", "Generic.Zils")
  }

  internal enum Scene {
    internal enum AskForCrashReportingPermissions {
      /// Crash reporting
      internal static let title = L10n.tr("Localizable", "Scene.AskForCrashReportingPermissions.Title")
      internal enum Button {
        /// Opt in
        internal static let accept = L10n.tr("Localizable", "Scene.AskForCrashReportingPermissions.Button.Accept")
        /// Opt out
        internal static let decline = L10n.tr("Localizable", "Scene.AskForCrashReportingPermissions.Button.Decline")
      }
      internal enum Checkbox {
        /// I have read and understood the crash reporting disclaimer
        internal static let readDisclaimer = L10n.tr("Localizable", "Scene.AskForCrashReportingPermissions.Checkbox.ReadDisclaimer")
      }
      internal enum Text {
        /// We would love to improve this app by collecting and analyzing anonymized crash reports sent by the app if it crashes. \n\nYou can opt out of this at anytime from the settings menu.\n\nThe app does not use any analytics beside crash reporting (Crashlytics), which you can verify yourself since this app is open source, search for `Analytics.logEvent` or `Analytics.setScreenName` in the code base which will not yield any search results.\n\nPlease 'Opt In' or 'Opt Out' of crash reporting.
        internal static let disclaimer = L10n.tr("Localizable", "Scene.AskForCrashReportingPermissions.Text.Disclaimer")
      }
    }
    internal enum BackUpKeystore {
      /// Keystore
      internal static let title = L10n.tr("Localizable", "Scene.BackUpKeystore.Title")
      internal enum Button {
        /// Copy keystore
        internal static let copy = L10n.tr("Localizable", "Scene.BackUpKeystore.Button.Copy")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied keystore
          internal static let didCopyKeystore = L10n.tr("Localizable", "Scene.BackUpKeystore.Event.Toast.DidCopyKeystore")
        }
      }
    }
    internal enum BackUpRevealedKeyPair {
      /// Backup key pair
      internal static let title = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Title")
      internal enum Buttons {
        /// Copy
        internal static let copy = L10n.tr("Localizable", "Scene.BackUpRevealedKeyPair.Buttons.Copy")
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
      /// Back up wallet
      internal static let title = L10n.tr("Localizable", "Scene.BackupWallet.Title")
      internal enum Button {
        /// Copy
        internal static let copy = L10n.tr("Localizable", "Scene.BackupWallet.Button.Copy")
        /// Done
        internal static let done = L10n.tr("Localizable", "Scene.BackupWallet.Button.Done")
      }
      internal enum Buttons {
        /// Reveal
        internal static let reveal = L10n.tr("Localizable", "Scene.BackupWallet.Buttons.Reveal")
      }
      internal enum Checkbox {
        /// I have securely backed up my private key.
        internal static let haveSecurelyBackedUp = L10n.tr("Localizable", "Scene.BackupWallet.Checkbox.HaveSecurelyBackedUp")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied keystore
          internal static let didCopyKeystore = L10n.tr("Localizable", "Scene.BackupWallet.Event.Toast.DidCopyKeystore")
        }
      }
      internal enum Label {
        /// Back up keys
        internal static let backUpKeys = L10n.tr("Localizable", "Scene.BackupWallet.Label.BackUpKeys")
        /// Keystore
        internal static let keystore = L10n.tr("Localizable", "Scene.BackupWallet.Label.Keystore")
        /// Private Key
        internal static let privateKey = L10n.tr("Localizable", "Scene.BackupWallet.Label.PrivateKey")
        /// Backing up the private key is the most important, but is also the most sensitive data. The private key is not tied to the encryption password, but the keystore is. Failing to backup your wallet may result in irreversible loss of assets.
        internal static let urgeBackup = L10n.tr("Localizable", "Scene.BackupWallet.Label.UrgeBackup")
      }
    }
    internal enum ChoosePincode {
      /// Set PIN
      internal static let title = L10n.tr("Localizable", "Scene.ChoosePincode.Title")
      internal enum Button {
        /// Done
        internal static let done = L10n.tr("Localizable", "Scene.ChoosePincode.Button.Done")
      }
      internal enum Text {
        /// The app PIN is an extra safety measure used only to unlock the app. It is not used to encrypt your private key. Before setting a PIN back up the wallet, otherwise you might get locked out if you forget it.
        internal static let pincodeOnlyLocksApp = L10n.tr("Localizable", "Scene.ChoosePincode.Text.PincodeOnlyLocksApp")
      }
    }
    internal enum ChooseWallet {
      internal enum Button {
        /// New Wallet
        internal static let newWallet = L10n.tr("Localizable", "Scene.ChooseWallet.Button.NewWallet")
        /// Restore existing wallet
        internal static let restoreWallet = L10n.tr("Localizable", "Scene.ChooseWallet.Button.RestoreWallet")
      }
      internal enum Label {
        /// Wallet
        internal static let impression = L10n.tr("Localizable", "Scene.ChooseWallet.Label.Impression")
        /// It is time to set up the wallet. Do you want to start fresh, or restore an existing wallet?
        internal static let setUpWallet = L10n.tr("Localizable", "Scene.ChooseWallet.Label.SetUpWallet")
      }
    }
    internal enum ConfirmNewPincode {
      /// Confirm PIN
      internal static let title = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Title")
      internal enum Button {
        /// Done
        internal static let done = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Button.Done")
      }
      internal enum Checkbox {
        /// I have securely backed up my PIN code
        internal static let pincodeIsBackedUp = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Checkbox.PincodeIsBackedUp")
      }
      internal enum Error {
        /// PIN does not match
        internal static let pincodesDoesNotMatch = L10n.tr("Localizable", "Scene.ConfirmNewPincode.Error.PincodesDoesNotMatch")
      }
    }
    internal enum ConfirmWalletRemoval {
      /// Remove wallet
      internal static let title = L10n.tr("Localizable", "Scene.ConfirmWalletRemoval.Title")
      internal enum Button {
        /// Confirm
        internal static let confirm = L10n.tr("Localizable", "Scene.ConfirmWalletRemoval.Button.Confirm")
      }
      internal enum Checkbox {
        /// I understand that I will permanently lose any asset in this wallet if I have not backed up the wallet.
        internal static let backUpWallet = L10n.tr("Localizable", "Scene.ConfirmWalletRemoval.Checkbox.BackUpWallet")
      }
      internal enum Label {
        /// Are you sure you want to remove your wallet?
        internal static let areYouSure = L10n.tr("Localizable", "Scene.ConfirmWalletRemoval.Label.AreYouSure")
      }
    }
    internal enum CreateNewWallet {
      /// New wallet
      internal static let title = L10n.tr("Localizable", "Scene.CreateNewWallet.Title")
      internal enum Button {
        /// Continue
        internal static let `continue` = L10n.tr("Localizable", "Scene.CreateNewWallet.Button.Continue")
      }
      internal enum Checkbox {
        /// I have securely backed up my encryption password
        internal static let passwordIsBackedUp = L10n.tr("Localizable", "Scene.CreateNewWallet.Checkbox.PasswordIsBackedUp")
      }
      internal enum Field {
        /// Confirm encryption password
        internal static let confirmEncryptionPassword = L10n.tr("Localizable", "Scene.CreateNewWallet.Field.ConfirmEncryptionPassword")
        /// Encryption password (min %d chars)
        internal static func encryptionPassword(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Scene.CreateNewWallet.Field.EncryptionPassword", p1)
        }
      }
      internal enum Labels {
        internal enum ChooseNewPassword {
          /// Set an encryption password
          internal static let title = L10n.tr("Localizable", "Scene.CreateNewWallet.Labels.ChooseNewPassword.Title")
          /// Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding.
          internal static let value = L10n.tr("Localizable", "Scene.CreateNewWallet.Labels.ChooseNewPassword.Value")
        }
      }
    }
    internal enum DecryptKeystoreToRevealKeyPair {
      /// Private key
      internal static let title = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Title")
      internal enum Button {
        /// Reveal
        internal static let reveal = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Button.Reveal")
      }
      internal enum Field {
        /// Encryption password
        internal static let encryptionPassword = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Field.EncryptionPassword")
      }
      internal enum Label {
        /// Enter your encryption password to reveal your private and public key.
        internal static let decryptToReaveal = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Label.DecryptToReaveal")
      }
    }
    internal enum EnsureThatYouAreNotBeingWatched {
      internal enum Button {
        /// I understand
        internal static let understand = L10n.tr("Localizable", "Scene.EnsureThatYouAreNotBeingWatched.Button.Understand")
      }
      internal enum Label {
        /// Make sure that you are in a private space where no one can see/record your personal data. Avoid public places, cameras and CCTV’s.
        internal static let makeSureAlone = L10n.tr("Localizable", "Scene.EnsureThatYouAreNotBeingWatched.Label.MakeSureAlone")
        /// Security
        internal static let security = L10n.tr("Localizable", "Scene.EnsureThatYouAreNotBeingWatched.Label.Security")
      }
    }
    internal enum GotTransactionReceipt {
      /// Confirmed
      internal static let title = L10n.tr("Localizable", "Scene.GotTransactionReceipt.Title")
      internal enum Button {
        /// Open details in browser
        internal static let openDetailsInBrowser = L10n.tr("Localizable", "Scene.GotTransactionReceipt.Button.OpenDetailsInBrowser")
      }
      internal enum Label {
        /// The network has successfully confirmed your transaction.
        internal static let confirmed = L10n.tr("Localizable", "Scene.GotTransactionReceipt.Label.Confirmed")
      }
      internal enum Labels {
        internal enum Fee {
          /// Transaction fee
          internal static let title = L10n.tr("Localizable", "Scene.GotTransactionReceipt.Labels.Fee.Title")
          /// %@E-12 Zil
          internal static func value(_ p1: Any) -> String {
            return L10n.tr("Localizable", "Scene.GotTransactionReceipt.Labels.Fee.Value", String(describing: p1))
          }
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
        }
      }
    }
    internal enum PollTransactionStatus {
      internal enum Button {
        /// Copy transaction id
        internal static let copyTransactionId = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.CopyTransactionId")
        /// Transaction details
        internal static let seeTransactionDetails = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SeeTransactionDetails")
        internal enum SkipWaitingOrDone {
          /// Done
          internal static let done = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SkipWaitingOrDone.Done")
          /// Skip waiting
          internal static let skip = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SkipWaitingOrDone.Skip")
        }
      }
      internal enum Event {
        internal enum Toast {
          /// Copied transaction id
          internal static let didCopyTransactionId = L10n.tr("Localizable", "Scene.PollTransactionStatus.Event.Toast.DidCopyTransactionId")
        }
      }
      internal enum Label {
        /// In a minute or two, when the network's finished processing, your balance will be updated and you can view transaction details.
        internal static let mightTakeSomeMinutes = L10n.tr("Localizable", "Scene.PollTransactionStatus.Label.MightTakeSomeMinutes")
        /// Transaction broadcasted
        internal static let transactionBroadcasted = L10n.tr("Localizable", "Scene.PollTransactionStatus.Label.TransactionBroadcasted")
      }
    }
    internal enum PrepareTransaction {
      /// Send
      internal static let title = L10n.tr("Localizable", "Scene.PrepareTransaction.Title")
      internal enum Button {
        /// Max
        internal static let maxAmount = L10n.tr("Localizable", "Scene.PrepareTransaction.Button.MaxAmount")
        /// Review Payment
        internal static let reviewPayment = L10n.tr("Localizable", "Scene.PrepareTransaction.Button.ReviewPayment")
      }
      internal enum Field {
        /// Amount in %@
        internal static func amount(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Amount", String(describing: p1))
        }
        /// Encryption password
        internal static let encryptionPassword = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.EncryptionPassword")
        /// Gas price in 'li' (min: %@ = %@)
        internal static func gasPrice(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Field.GasPrice", String(describing: p1), String(describing: p2))
        }
        /// To address
        internal static let recipient = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Recipient")
      }
      internal enum Label {
        /// Transaction fee: %@
        internal static func costOfTransactionInZil(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Label.CostOfTransactionInZil", String(describing: p1))
        }
        /// Gas price is measured in %@
        internal static func gasInSmallUnits(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Label.GasInSmallUnits", String(describing: p1))
        }
      }
      internal enum Labels {
        internal enum Balance {
          /// Current balance
          internal static let title = L10n.tr("Localizable", "Scene.PrepareTransaction.Labels.Balance.Title")
        }
      }
    }
    internal enum Receive {
      /// Receive
      internal static let title = L10n.tr("Localizable", "Scene.Receive.Title")
      internal enum Button {
        /// Copy
        internal static let copyMyAddress = L10n.tr("Localizable", "Scene.Receive.Button.CopyMyAddress")
        /// Request payment
        internal static let requestPayment = L10n.tr("Localizable", "Scene.Receive.Button.RequestPayment")
      }
      internal enum Event {
        internal enum Toast {
          /// Copied address
          internal static let didCopyAddress = L10n.tr("Localizable", "Scene.Receive.Event.Toast.DidCopyAddress")
        }
      }
      internal enum Field {
        /// Request amount in %@
        internal static func requestAmount(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Scene.Receive.Field.RequestAmount", String(describing: p1))
        }
      }
      internal enum Label {
        /// My public address
        internal static let myPublicAddress = L10n.tr("Localizable", "Scene.Receive.Label.MyPublicAddress")
      }
    }
    internal enum RemovePincode {
      /// Unlock to remove
      internal static let title = L10n.tr("Localizable", "Scene.RemovePincode.Title")
    }
    internal enum RestoreWallet {
      /// Restore existing wallet
      internal static let title = L10n.tr("Localizable", "Scene.RestoreWallet.Title")
      internal enum Button {
        /// Restore
        internal static let restoreWallet = L10n.tr("Localizable", "Scene.RestoreWallet.Button.RestoreWallet")
      }
      internal enum Field {
        /// Confirm encryption password
        internal static let confirmEncryptionPassword = L10n.tr("Localizable", "Scene.RestoreWallet.Field.ConfirmEncryptionPassword")
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Field.PrivateKey")
        internal enum EncryptionPassword {
          /// Encryption password (min %d chars)
          internal static func keystore(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Scene.RestoreWallet.Field.EncryptionPassword.Keystore", p1)
          }
          /// New encryption password (min %d chars)
          internal static func privateKey(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Scene.RestoreWallet.Field.EncryptionPassword.PrivateKey", p1)
          }
        }
      }
      internal enum Label {
        internal enum Header {
          /// Restore with keystore
          internal static let keystore = L10n.tr("Localizable", "Scene.RestoreWallet.Label.Header.Keystore")
          /// Restore with private key
          internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Label.Header.PrivateKey")
        }
      }
      internal enum Segment {
        /// Keystore
        internal static let keystore = L10n.tr("Localizable", "Scene.RestoreWallet.Segment.Keystore")
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Segment.PrivateKey")
      }
    }
    internal enum ReviewTransactionBeforeSigning {
      /// Summary
      internal static let title = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Title")
      internal enum Button {
        /// To signing
        internal static let hasReviewedProceedToSigning = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Button.HasReviewedProceedToSigning")
      }
      internal enum Checkbox {
        /// I've reviewed the payment and understand I'm responsible for any loss if anything is incorrect. 
        internal static let hasReviewedPayment = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Checkbox.HasReviewedPayment")
      }
      internal enum Label {
        /// Amount
        internal static let amount = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.Amount")
        /// Amount to recipient
        internal static let amountToSend = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.AmountToSend")
        /// Recipient
        internal static let recipient = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.Recipient")
        /// Transaction total cost
        internal static let totalCostOfTransaction = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.TotalCostOfTransaction")
        /// Transaction fee
        internal static let transactionFee = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.TransactionFee")
        internal enum Address {
          /// Address on new bech32 format
          internal static let bech32 = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.Address.Bech32")
          /// Address on old base16 format
          internal static let legacy = L10n.tr("Localizable", "Scene.ReviewTransactionBeforeSigning.Label.Address.Legacy")
        }
      }
    }
    internal enum ScanQRCode {
      /// Scan QR
      internal static let title = L10n.tr("Localizable", "Scene.ScanQRCode.Title")
      internal enum Event {
        internal enum Toast {
          internal enum IncompatibleQrCode {
            /// Dismiss
            internal static let dismiss = L10n.tr("Localizable", "Scene.ScanQRCode.Event.Toast.IncompatibleQrCode.Dismiss")
            /// QR code contains no compatible Zilliqa address
            internal static let title = L10n.tr("Localizable", "Scene.ScanQRCode.Event.Toast.IncompatibleQrCode.Title")
          }
        }
      }
    }
    internal enum Settings {
      /// Settings
      internal static let title = L10n.tr("Localizable", "Scene.Settings.Title")
      internal enum Cell {
        /// Acknowledgements
        internal static let acknowledgements = L10n.tr("Localizable", "Scene.Settings.Cell.Acknowledgements")
        /// Backup wallet
        internal static let backupWallet = L10n.tr("Localizable", "Scene.Settings.Cell.BackupWallet")
        /// Crash reporting permissions
        internal static let crashReportingPermissions = L10n.tr("Localizable", "Scene.Settings.Cell.CrashReportingPermissions")
        /// Unreliable cryptography
        internal static let readCustomECCWarning = L10n.tr("Localizable", "Scene.Settings.Cell.ReadCustomECCWarning")
        /// Remove pincode
        internal static let removePincode = L10n.tr("Localizable", "Scene.Settings.Cell.RemovePincode")
        /// Remove wallet
        internal static let removeWallet = L10n.tr("Localizable", "Scene.Settings.Cell.RemoveWallet")
        /// Report issue (Github login required)
        internal static let reportIssueOnGithub = L10n.tr("Localizable", "Scene.Settings.Cell.ReportIssueOnGithub")
        /// Set pincode
        internal static let setPincode = L10n.tr("Localizable", "Scene.Settings.Cell.SetPincode")
        /// Star us on Github
        internal static let starUsOnGithub = L10n.tr("Localizable", "Scene.Settings.Cell.StarUsOnGithub")
        /// Terms of service
        internal static let termsOfService = L10n.tr("Localizable", "Scene.Settings.Cell.Terms of service")
      }
      internal enum Footer {
        /// Connected to %s
        internal static func network(_ p1: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "Scene.Settings.Footer.Network", p1)
        }
      }
    }
    internal enum SignTransaction {
      internal enum Button {
        /// Confirm
        internal static let confirm = L10n.tr("Localizable", "Scene.SignTransaction.Button.Confirm")
      }
      internal enum Field {
        /// Encryption password
        internal static let encryptionPassword = L10n.tr("Localizable", "Scene.SignTransaction.Field.EncryptionPassword")
      }
      internal enum Label {
        /// Confirm transaction with your password
        internal static let signTransactionWithEncryptionPassword = L10n.tr("Localizable", "Scene.SignTransaction.Label.SignTransactionWithEncryptionPassword")
      }
    }
    internal enum TermsOfService {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.TermsOfService.Button.Accept")
      }
      internal enum Label {
        /// Terms of service
        internal static let termsOfService = L10n.tr("Localizable", "Scene.TermsOfService.Label.TermsOfService")
      }
    }
    internal enum UnlockAppWithPincode {
      /// Unlock app with PIN or FaceId/TouchId
      internal static let label = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Label")
      /// Unlock app
      internal static let title = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Title")
      internal enum Biometrics {
        /// Use PIN
        internal static let fallBack = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Biometrics.FallBack")
        /// Unlock app easily with FaceId/TouchId
        internal static let reason = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Biometrics.Reason")
      }
    }
    internal enum WarningCustomECC {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.WarningCustomECC.Button.Accept")
      }
      internal enum Label {
        /// Unreliable ECC
        internal static let header = L10n.tr("Localizable", "Scene.WarningCustomECC.Label.Header")
      }
    }
    internal enum Welcome {
      internal enum Button {
        /// Start
        internal static let start = L10n.tr("Localizable", "Scene.Welcome.Button.Start")
      }
      internal enum Label {
        /// Welcome to Zhip - the worlds first and only iOS wallet for Zilliqa.
        internal static let body = L10n.tr("Localizable", "Scene.Welcome.Label.Body")
        /// Welcome
        internal static let header = L10n.tr("Localizable", "Scene.Welcome.Label.Header")
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
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
