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
        /// Are you sure this is a Zilliqa address? It is not checksummed. This might still be a valid address.
        internal static let addressNotChecksummed = L10n.tr("Localizable", "Error.Input.Address.AddressNotChecksummed")
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
        /// Insufficient funds
        internal static let exceedingBalance = L10n.tr("Localizable", "Error.Input.Amount.ExceedingBalance")
        /// String not a number
        internal static let nonNumericString = L10n.tr("Localizable", "Error.Input.Amount.NonNumericString")
        /// Must be at most %@
        internal static func tooLarge(_ p1: String) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooLarge", p1)
        }
        /// Must be at least %@
        internal static func tooSmall(_ p1: String) -> String {
          return L10n.tr("Localizable", "Error.Input.Amount.TooSmall", p1)
        }
      }
      internal enum Keystore {
        /// Bad JSON, control format.
        internal static let badFormatOrInput = L10n.tr("Localizable", "Error.Input.Keystore.BadFormatOrInput")
        /// Keystore was not encrypted by this passphrase
        internal static let incorrectPassphrase = L10n.tr("Localizable", "Error.Input.Keystore.IncorrectPassphrase")
      }
      internal enum Passphrase {
        /// Passphrases does not match
        internal static let confirmingPassphraseMismatch = L10n.tr("Localizable", "Error.Input.Passphrase.ConfirmingPassphraseMismatch")
        /// Incorrect passphrase
        internal static let incorrectPassphrase = L10n.tr("Localizable", "Error.Input.Passphrase.IncorrectPassphrase")
        /// Incorrect passphrase, if you can't remember it do NOT continue, restart the wallet creation from the beginning.
        internal static let incorrectPassphraseDuringBackupOfNewlyCreatedWallet = L10n.tr("Localizable", "Error.Input.Passphrase.IncorrectPassphraseDuringBackupOfNewlyCreatedWallet")
        /// Passphrase have length >%d
        internal static func tooShort(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Error.Input.Passphrase.TooShort", p1)
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
    internal static func balanceWasUpdatedAt(_ p1: String) -> String {
      return L10n.tr("Localizable", "Formatter.BalanceWasUpdatedAt", p1)
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
    internal enum AskForAnalyticsPermissions {
      /// Analytics
      internal static let title = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Title")
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Button.Accept")
        /// Decline
        internal static let decline = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Button.Decline")
      }
      internal enum Checkbox {
        /// I have read and understood the analytics disclaimer
        internal static let readDisclaimer = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Checkbox.ReadDisclaimer")
      }
      internal enum Text {
        /// We would love to improve this app by collecting and analyzing anonymized events sent by the app while you are using it. Such events could for example be menu selections and button taps (so we know if you use the QR code scanning feature for example). You can opt out of this at anytime from the settings menu. We never send any sensitive information of course, which you can verify yourself since this app is open source. Search for 'TrackableEvent' in the source code (you will find a link to Github in the settings meny).
        internal static let disclaimer = L10n.tr("Localizable", "Scene.AskForAnalyticsPermissions.Text.Disclaimer")
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
        /// Backing up the private key is the most important, but is also the most sensitive data. The private key is not tied to the encryption passphrase, but the keystore is. Failing to backup your wallet may result in irreversible loss of assets.
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
        /// The app PIN is an additional safety measure used only to unlock the app. It is not used to encrypt your private key. Make sure that you have backed up you wallet, since you might get locked out of the app if you forget the PIN.
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
        /// I have securely backed up my encryption passphrase
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
      internal enum Labels {
        internal enum ChooseNewPassphrase {
          /// Set an encryption passphrase
          internal static let title = L10n.tr("Localizable", "Scene.CreateNewWallet.Labels.ChooseNewPassphrase.Title")
          /// Your encryption passphrase is used to encrypt your private key. Make sure to back up your encryption passphrase before proceeding.
          internal static let value = L10n.tr("Localizable", "Scene.CreateNewWallet.Labels.ChooseNewPassphrase.Value")
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
        /// Encryption passphrase
        internal static let encryptionPassphrase = L10n.tr("Localizable", "Scene.DecryptKeystoreToRevealKeyPair.Field.EncryptionPassphrase")
      }
      internal enum Label {
        /// Enter your encryption passphrase to reveal your private and public key.
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
          internal static func value(_ p1: String) -> String {
            return L10n.tr("Localizable", "Scene.GotTransactionReceipt.Labels.Fee.Value", p1)
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
        /// Transaction details
        internal static let seeTransactionDetails = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SeeTransactionDetails")
        internal enum SkipWaitingOrDone {
          /// Done
          internal static let done = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SkipWaitingOrDone.Done")
          /// Skip waiting
          internal static let skip = L10n.tr("Localizable", "Scene.PollTransactionStatus.Button.SkipWaitingOrDone.Skip")
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
        /// Send
        internal static let send = L10n.tr("Localizable", "Scene.PrepareTransaction.Button.Send")
      }
      internal enum Field {
        /// Amount
        internal static let amount = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Amount")
        /// Encryption passphrase
        internal static let encryptionPassphrase = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.EncryptionPassphrase")
        /// Gas price (min %@)
        internal static func gasPrice(_ p1: String) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Field.GasPrice", p1)
        }
        /// To address
        internal static let recipient = L10n.tr("Localizable", "Scene.PrepareTransaction.Field.Recipient")
      }
      internal enum Label {
        /// Gas price is measured in %@
        internal static func gasInSmallUnits(_ p1: String) -> String {
          return L10n.tr("Localizable", "Scene.PrepareTransaction.Label.GasInSmallUnits", p1)
        }
        /// Transaction Id
        internal static let transactionId = L10n.tr("Localizable", "Scene.PrepareTransaction.Label.TransactionId")
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
        /// Request amount
        internal static let requestAmount = L10n.tr("Localizable", "Scene.Receive.Field.RequestAmount")
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
        /// Confirm encryption passphrase
        internal static let confirmEncryptionPassphrase = L10n.tr("Localizable", "Scene.RestoreWallet.Field.ConfirmEncryptionPassphrase")
        /// Private key
        internal static let privateKey = L10n.tr("Localizable", "Scene.RestoreWallet.Field.PrivateKey")
        internal enum EncryptionPassphrase {
          /// Encryption passphrase (min %d chars)
          internal static func keystore(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Scene.RestoreWallet.Field.EncryptionPassphrase.Keystore", p1)
          }
          /// New encryption passphrase (min %d chars)
          internal static func privateKey(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Scene.RestoreWallet.Field.EncryptionPassphrase.PrivateKey", p1)
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
    internal enum ScanQRCode {
      /// Scan QR
      internal static let title = L10n.tr("Localizable", "Scene.ScanQRCode.Title")
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
        /// Change analytics permissions
        internal static let changeAnalyticsPermissions = L10n.tr("Localizable", "Scene.Settings.Cell.ChangeAnalyticsPermissions")
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
      internal enum Label {
        /// Terms of service
        internal static let termsOfService = L10n.tr("Localizable", "Scene.TermsOfService.Label.TermsOfService")
      }
    }
    internal enum UnlockAppWithPincode {
      /// Unlock app
      internal static let title = L10n.tr("Localizable", "Scene.UnlockAppWithPincode.Title")
    }
    internal enum WarningERC20 {
      internal enum Button {
        /// Accept
        internal static let accept = L10n.tr("Localizable", "Scene.WarningERC20.Button.Accept")
        /// Do not show this again
        internal static let doNotShowAgain = L10n.tr("Localizable", "Scene.WarningERC20.Button.DoNotShowAgain")
      }
      internal enum Checkbox {
        /// I understand that ERC-20 ZILs are not supported
        internal static let understandsERC20Incompatibility = L10n.tr("Localizable", "Scene.WarningERC20.Checkbox.UnderstandsERC20Incompatibility")
      }
      internal enum Label {
        /// ERC-20 tokens
        internal static let erc20Tokens = L10n.tr("Localizable", "Scene.WarningERC20.Label.Erc20Tokens")
      }
      internal enum Text {
        /// This is a wallet for the Zilliqa network. Do NOT send ERC-20 ZILs to native Zilliqa addresses.\n\nTransferring ERC-20 ZILs to a native Zilliqa address - or vice versa - will cause irreparable loss.
        internal static let warningERC20 = L10n.tr("Localizable", "Scene.WarningERC20.Text.WarningERC20")
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
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
