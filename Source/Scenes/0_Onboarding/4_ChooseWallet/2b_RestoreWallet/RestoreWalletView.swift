//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

import Zesame

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.RestoreWallet
private typealias Segment = RestoreWalletViewModel.InputFromView.Segment

// MARK: - RestoreWalletView
final class RestoreWalletView: ScrollableStackViewOwner {

    private let bag = DisposeBag()

    // MARK: - Subviews
    private lazy var restorationMethodSegmentedControl  = UISegmentedControl()
    private lazy var headerLabel                        = UILabel()
    private lazy var restoreUsingPrivateKeyView         = RestoreUsingPrivateKeyView()
    fileprivate lazy var restoreUsingKeyStoreView       = RestoreUsingKeystoreView()
    private lazy var containerView                      = UIView()
    fileprivate lazy var restoreWalletButton                = ButtonWithSpinner()

    lazy var stackViewStyle = UIStackView.Style([
        headerLabel,
        containerView,
        restoreWalletButton
        ], spacing: 8)

    override func setup() {
        setupSubviews()
    }

    override func setupScrollViewConstraints() {
        scrollView.bottomToSuperview()
        scrollView.leadingToSuperview()
        scrollView.trailingToSuperview()
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

    var keystoreRestorationValidatino: Binder<AnyValidation> {
        return Binder<AnyValidation>(self) {
            $0.restoreUsingKeyStoreView.restorationErrorValidation($1)
            $0.selectSegment(.keystore)
            $0.restoreWalletButton.isEnabled = false
        }
    }
}

// MARK: - Private
private extension RestoreWalletView {

    func setupSubviews() {
        headerLabel.withStyle(.header)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        [restoreUsingPrivateKeyView, restoreUsingKeyStoreView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
            $0.edgesToSuperview()
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
        addSubview(restorationMethodSegmentedControl)
        restorationMethodSegmentedControl.topToSuperview(offset: 10, usingSafeArea: true)
        restorationMethodSegmentedControl.centerXToSuperview()
        restorationMethodSegmentedControl.bottomToTop(of: scrollView)

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
