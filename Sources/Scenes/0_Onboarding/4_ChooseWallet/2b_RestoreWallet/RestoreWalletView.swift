// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

        restorationMethodSegmentedControl.selectedSegmentTintColor = .teal
        
        restorationMethodSegmentedControl.addBorder(.init(color: .teal, width: 1))
        
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
