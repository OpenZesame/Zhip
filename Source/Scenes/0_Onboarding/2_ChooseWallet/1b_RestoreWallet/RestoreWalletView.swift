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
    private lazy var restorationMethodSegmentedControl = UISegmentedControl(frame: .zero)
    private lazy var restoreUsingPrivateKeyView = RestoreUsingPrivateKeyView()
    private lazy var restoreUsingKeyStoreView = RestoreUsingKeystoreView()
    private lazy var restoreWalletButton: ButtonWithSpinner = ButtonWithSpinner(title: €.Button.restoreWallet)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
        }

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
    func setup() {

        addSubview(restorationMethodSegmentedControl)
        addSubview(restoreWalletButton)
        restoreWalletButton.bottomToSuperview(offset: -50)
        restoreWalletButton.centerXToSuperview()

        func setupSubview(_ view: UIView) {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.leadingToSuperview()
            view.trailingToSuperview()
            view.topToBottom(of: restorationMethodSegmentedControl)
            view.bottomToTop(of: restoreWalletButton, offset: 10)
            view.isHidden = true
        }

        [restoreUsingPrivateKeyView, restoreUsingKeyStoreView].forEach {
            setupSubview($0)
        }

        setupSegmentedControl()
    }

    // swiftlint:disable:next function_body_length
    func setupSegmentedControl() {
        restorationMethodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        restorationMethodSegmentedControl.topToSuperview(offset: 8)
        restorationMethodSegmentedControl.centerXToSuperview()

        func add(segment: Segment, titled title: String) {
            restorationMethodSegmentedControl.insertSegment(withTitle: title, at: segment.rawValue, animated: false)
        }

        add(segment: .privateKey, titled: €.Segment.privateKey)
        add(segment: .keystore, titled: €.Segment.keystore)

        restorationMethodSegmentedControl.rx.value
            .asDriver()
            .filter { $0 >= 0 }
            .do(onNext: { [unowned self] in self.selectedSegment(at: $0) })
            .drive().disposed(by: bag)

        func startSegmentedControl(at segment: Segment) {
            restorationMethodSegmentedControl.selectedSegmentIndex = segment.rawValue
            selectedSegment(at: segment.rawValue)
        }

        startSegmentedControl(at: .privateKey)
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
            viewModel.isRestoring               --> restoreWalletButton.rx.isLoading,
            viewModel.isRestoreButtonEnabled    --> restoreWalletButton.rx.isEnabled
        ]
    }
}
