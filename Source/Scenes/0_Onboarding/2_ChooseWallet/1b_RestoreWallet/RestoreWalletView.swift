//
//  RestoreWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import Zesame

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.RestoreWallet

private func makeRestoreButton() -> ButtonWithSpinner {
    return ButtonWithSpinner(title: €.Button.restoreWallet)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
    }
}

final class RestoreWalletView: UIView, EmptyInitializable {

    // MARK: - RestoreWithPrivateKeyView
    final class RestoreUsingPrivateKeyView: ScrollingStackView {
        private lazy var privateKeyField = TextField(placeholder: €.Field.privateKey, type: .hexadecimal)
            .withStyle(.password)
        private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

        private lazy var confirmEncryptionPassphraseField = TextField(placeholder: €.Field.confirmEncryptionPassphrase, type: .text).withStyle(.password)

        fileprivate lazy var restoreWalletButton = makeRestoreButton()

        lazy var stackViewStyle: UIStackView.Style = [
            privateKeyField,
            encryptionPassphraseField,
            confirmEncryptionPassphraseField,
            restoreWalletButton,
            .spacer
        ]
    }

    // MARK: - RestoreWithKeystoreView
    final class RestoreUsingKeystoreView: ScrollingStackView {
        private lazy var keystoreTextView = UITextView(frame: .zero).withStyle(.editable)

        private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

        fileprivate lazy var restoreWalletButton = makeRestoreButton()

        lazy var stackViewStyle: UIStackView.Style = [
            keystoreTextView,
            encryptionPassphraseField,
            restoreWalletButton,
            .spacer
        ]
        override func setup() {
            keystoreTextView.addBorder()
            keystoreTextView.height(200)
        }
    }

    // MARK: - Subviews
    private let bag = DisposeBag()
    private let keyRestorationSubject = PublishSubject<KeyRestoration>()
    private lazy var restorationMethodSegmentedControl = UISegmentedControl(frame: .zero)
    private lazy var restoreUsingPrivateKeyView = RestoreUsingPrivateKeyView()
    private lazy var restoreUsingKeyStoreView = RestoreUsingKeystoreView()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

private extension RestoreWalletView {
    func setup() {

        addSubview(restorationMethodSegmentedControl)
        func setupSubview(_ view: UIView) {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.edgesToSuperview(excluding: [.top])
            view.topToBottom(of: restorationMethodSegmentedControl)
            view.isHidden = true
        }

        [restoreUsingPrivateKeyView, restoreUsingKeyStoreView].forEach {
            setupSubview($0)
        }

        setupSegmentedControl()
    }

    func setupSegmentedControl() {
        restorationMethodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        restorationMethodSegmentedControl.topToSuperview(offset: 8)
        restorationMethodSegmentedControl.centerXToSuperview()
        restorationMethodSegmentedControl.insertSegment(withTitle: €.Segment.privateKey, at: 0, animated: false)
        restorationMethodSegmentedControl.insertSegment(withTitle: €.Segment.keystore, at: 1, animated: false)

        restorationMethodSegmentedControl.rx.value
            .asDriver()
            .filter { $0 >= 0 }
            .do(onNext: { [unowned self] in self.selectedSegment(at: $0) })
            .drive().disposed(by: bag)

        func startSegmentedControl(at index: Int) {
            restorationMethodSegmentedControl.selectedSegmentIndex = index
            selectedSegment(at: index)
        }

        startSegmentedControl(at: 0)
    }

    func selectedSegment(at index: Int) {
        switch index {
        case 0:
            restoreUsingPrivateKeyView.isHidden = false
            restoreUsingKeyStoreView.isHidden = true
        case 1:
            restoreUsingPrivateKeyView.isHidden = true
            restoreUsingKeyStoreView.isHidden = false
        default: incorrectImplementation("Unhandled case")
        }
    }
}

extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var inputFromView: InputFromView {
        return InputFromView(
            keyRestoration: keyRestorationSubject.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        let privateKeyViewModel = viewModel.restoreUsingPrivateKeyViewModel
        let keystoreViewModel = viewModel.restoreUsingKeyStoreViewModel

        let privateKeyOutput = privateKeyViewModel.transform(input: restoreUsingPrivateKeyView.input)
        let keystoreOutput = keystoreViewModel.transform(input: restoreUsingKeyStoreView.input)

        let keyRestoration = Driver.merge(privateKeyOutput.keyRestoration, keystoreOutput.keyRestoration)

        return [
            restoreUsingPrivateKeyView.populate(with: privateKeyOutput),
            restoreUsingKeyStoreView.populate(with: keystoreOutput)
        ].flatMap { $0 } + [
            viewModel.isRestoring --> restoreUsingPrivateKeyView.restoreWalletButton.rx.isLoading,
            viewModel.isRestoring --> restoreUsingKeyStoreView.restoreWalletButton.rx.isLoading,

            keyRestoration.do(onNext: { [unowned self] in
                self.keyRestorationSubject.onNext($0)
            }).drive()
        ]
    }
}

extension RestoreWalletView.RestoreUsingKeystoreView: ViewModelled {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel
    var inputFromView: InputFromView {

        return InputFromView(
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPassphrasePlaceholder   --> encryptionPassphraseField.rx.placeholder,
            viewModel.isRestoreButtonEnabled            --> restoreWalletButton.rx.isEnabled
        ]
    }
}

extension RestoreWalletView.RestoreUsingPrivateKeyView: ViewModelled {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel
    var inputFromView: InputFromView {

        return InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPassphrasePlaceholder   --> encryptionPassphraseField.rx.placeholder,
            viewModel.isRestoreButtonEnabled            --> restoreWalletButton.rx.isEnabled
        ]
    }
}
