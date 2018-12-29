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
private typealias Segment = RestoreWalletViewModel.InputFromView.Segment

// MARK: - RestoreWalletView
final class RestoreWalletView: UIView, EmptyInitializable {

    private let bag = DisposeBag()

    // MARK: - Subviews
    private lazy var restorationMethodSegmentedControl  = UISegmentedControl()
    private lazy var headerLabel                        = UILabel()
    private lazy var restoreUsingPrivateKeyView         = RestoreUsingPrivateKeyView()
    fileprivate lazy var restoreUsingKeyStoreView       = RestoreUsingKeystoreView()
    fileprivate lazy var restoreWalletButton                = ButtonWithSpinner()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

// MARK: - Private
private extension RestoreWalletView {

    // swiftlint:disable:next function_body_length
    func setup() {

        headerLabel.withStyle(.header)

        addSubview(restorationMethodSegmentedControl)
        addSubview(headerLabel)
        headerLabel.leadingToSuperview(offset: UIStackView.Style.defaultMargin)
        headerLabel.trailingToSuperview(offset: UIStackView.Style.defaultMargin)
        headerLabel.topToBottom(of: restorationMethodSegmentedControl, offset: 24)
        addSubview(restoreWalletButton)
        restoreWalletButton.bottomToSuperview(offset: -50)
        restoreWalletButton.leadingToSuperview(offset: UIStackView.Style.defaultMargin)
        restoreWalletButton.trailingToSuperview(offset: UIStackView.Style.defaultMargin)

        func setupSubview(_ view: UIView) {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.leadingToSuperview()
            view.trailingToSuperview()
            view.topToBottom(of: headerLabel)
            view.bottomToTop(of: restoreWalletButton, offset: -30)
            view.isHidden = true
        }

        [restoreUsingPrivateKeyView, restoreUsingKeyStoreView].forEach {
            setupSubview($0)
        }

        restoreWalletButton.withStyle(.primary) {
            $0.title(€.Button.restoreWallet)
                .disabled()
        }

        setupSegmentedControl()
    }

    // swiftlint:disable:next function_body_length
    func setupSegmentedControl() {
        restorationMethodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        restorationMethodSegmentedControl.topToSuperview(usingSafeArea: true)
        restorationMethodSegmentedControl.centerXToSuperview()

        func add(segment: Segment, titled title: String) {
            restorationMethodSegmentedControl.insertSegment(withTitle: title, at: segment.rawValue, animated: false)
        }

        restorationMethodSegmentedControl.tintColor = .teal
        let whiteFontAttributes = [NSAttributedString.Key.font: UIFont.hint,
                             NSAttributedString.Key.foregroundColor: UIColor.white]

        let tealFontAttributes = [NSAttributedString.Key.font: UIFont.hint,
                                   NSAttributedString.Key.foregroundColor: UIColor.teal]

        restorationMethodSegmentedControl.setTitleTextAttributes(whiteFontAttributes, for: .selected)
        restorationMethodSegmentedControl.setTitleTextAttributes(tealFontAttributes, for: .normal)

        add(segment: .keystore, titled: €.Segment.keystore)
        add(segment: .privateKey, titled: €.Segment.privateKey)

        restorationMethodSegmentedControl.rx.value
            .asDriver()
            .map { Segment(rawValue: $0) }
            .filterNil()
            .do(onNext: { [unowned self] in self.switchToViewFor(selectedSegment: $0) })
            .drive().disposed(by: bag)

        selectSegment(.privateKey)
    }

    func switchToViewFor(selectedSegment: Segment) {
        switch selectedSegment {
        case .privateKey:
            restoreUsingPrivateKeyView.isHidden = false
            restoreUsingKeyStoreView.isHidden = true
        case .keystore:
            restoreUsingPrivateKeyView.isHidden = true
            restoreUsingKeyStoreView.isHidden = false
        }
    }

    func selectSegment(_ segment: Segment) {
        restorationMethodSegmentedControl.selectedSegmentIndex = segment.rawValue
        restorationMethodSegmentedControl.sendActions(for: .valueChanged)
    }
}

// MARK: - ViewModelled
extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    
    var inputFromView: InputFromView {
        return InputFromView(
            selectedSegment: restorationMethodSegmentedControl.rx.value.asDriver().map { Segment(rawValue: $0) }.filterNil(),
            keyRestorationUsingPrivateKey: restoreUsingPrivateKeyView.viewModelOutput.keyRestoration,
            keyRestorationUsingKeystore: restoreUsingKeyStoreView.viewModelOutput.keyRestoration,
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.headerLabel               --> headerLabel.rx.text,
            viewModel.isRestoring               --> restoreWalletButton.rx.isLoading,
            viewModel.isRestoreButtonEnabled    --> restoreWalletButton.rx.isEnabled,
            viewModel.keystoreRestorationError  --> keystoreRestorationValidatino
        ]
    }

    var keystoreRestorationValidatino: Binder<Validation> {
        return Binder<Validation>(self) {
            $0.restoreUsingKeyStoreView.restorationErrorValidation($1)
            $0.selectSegment(.keystore)
            $0.restoreWalletButton.isEnabled = false
        }
    }

}
