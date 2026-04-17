//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import UIKit
import Zesame

private typealias Segment = RestoreWalletViewModel.InputFromView.Segment

// MARK: - RestoreWalletView

final class RestoreWalletView: ScrollableStackViewOwner {
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Subviews

    private lazy var restorationMethodSegmentedControl = UISegmentedControl()
    private lazy var headerLabel = UILabel()
    private lazy var restoreUsingPrivateKeyView = RestoreUsingPrivateKeyView()
    fileprivate lazy var restoreUsingKeyStoreView = RestoreUsingKeystoreView()
    private lazy var containerView = UIView()
    fileprivate lazy var restoreWalletButton = ButtonWithSpinner()

    lazy var stackViewStyle = UIStackView.Style([
        headerLabel,
        containerView,
        restoreWalletButton,
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
        let segmentValue = restorationMethodSegmentedControl.publisher(for: .valueChanged)
            .map { [weak restorationMethodSegmentedControl] _ in
                restorationMethodSegmentedControl?.selectedSegmentIndex ?? 0
            }
            .prepend(restorationMethodSegmentedControl.selectedSegmentIndex)
            .eraseToAnyPublisher()
        return InputFromView(
            selectedSegment: segmentValue.map { Segment(rawValue: $0) }.filterNil().eraseToAnyPublisher(),
            keyRestorationUsingPrivateKey: restoreUsingPrivateKeyView.viewModelOutput.keyRestoration,
            keyRestorationUsingKeystore: restoreUsingKeyStoreView.viewModelOutput.keyRestoration,
            restoreTrigger: restoreWalletButton.tapPublisher
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [AnyCancellable] {
        [
            viewModel.headerLabel --> headerLabel.textBinder,
            viewModel.isRestoring --> restoreWalletButton.isLoadingBinder,
            viewModel.isRestoreButtonEnabled --> restoreWalletButton.isEnabledBinder,
            viewModel.keystoreRestorationError --> keystoreRestorationValidatino,
        ]
    }

    var keystoreRestorationValidatino: Binder<AnyValidation> {
        Binder<AnyValidation>(self) {
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

        for item in [restoreUsingPrivateKeyView, restoreUsingKeyStoreView] {
            item.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(item)
            item.edgesToSuperview()
        }

        restoreWalletButton.withStyle(.primary) {
            $0.title(String(localized: .RestoreWallet.restore))
                .disabled()
        }

        setupSegmentedControl()
    }

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

        let whiteFontAttributes = [
            NSAttributedString.Key.font: UIFont.hint,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]

        let tealFontAttributes = [
            NSAttributedString.Key.font: UIFont.hint,
            NSAttributedString.Key.foregroundColor: UIColor.teal,
        ]

        restorationMethodSegmentedControl.setTitleTextAttributes(whiteFontAttributes, for: .selected)
        restorationMethodSegmentedControl.setTitleTextAttributes(tealFontAttributes, for: .normal)

        add(segment: .keystore, titled: String(localized: .RestoreWallet.keystoreSegment))
        add(segment: .privateKey, titled: String(localized: .RestoreWallet.privateKeySegment))

        restorationMethodSegmentedControl.publisher(for: .valueChanged)
            .map { [weak restorationMethodSegmentedControl] _ in restorationMethodSegmentedControl?.selectedSegmentIndex ?? 0 }
            .map { Segment(rawValue: $0) }
            .filterNil()
            .handleEvents(receiveOutput: { [unowned self] in switchToViewFor(selectedSegment: $0) })
            .sink { _ in }.store(in: &cancellables)

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
