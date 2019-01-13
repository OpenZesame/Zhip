//
//  AskForAnalyticsPermissionsView.swift
//  Zhip
//
//  Created by Andrei Radulescu on 09/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import TinyConstraints
import RxSwift

final class AskForAnalyticsPermissionsView: BaseSceneView {

    private lazy var imageView                      = UIImageView()
    private lazy var headerLabel                    = UILabel()
    private lazy var disclaimerTextView             = UITextView()
    private lazy var hasReadDisclaimerCheckbox      = CheckboxWithLabel()
    private lazy var declineButton                  = UIButton()
    private lazy var acceptButton                   = UIButton()
    private lazy var buttonsStackView               = UIStackView(arrangedSubviews: [declineButton, acceptButton])

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        disclaimerTextView,
        hasReadDisclaimerCheckbox,
        buttonsStackView
    ]

    override func setup() {
        setupSubviews()
    }
}

// MARK: - ViewModelled
extension AskForAnalyticsPermissionsView: ViewModelled {
    typealias ViewModel = AskForAnalyticsPermissionsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.areButtonsEnabled --> declineButton.rx.isEnabled,
            viewModel.areButtonsEnabled --> acceptButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            isHaveReadDisclaimerCheckboxChecked: hasReadDisclaimerCheckbox.rx.isChecked.asDriver(),
            acceptTrigger: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            declineTrigger: declineButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.AskForAnalyticsPermissions
private typealias Icon = Asset.Icons.Large
private extension AskForAnalyticsPermissionsView {
    func setupSubviews() {
        imageView.withStyle(.default) {
            $0.asset(Icon.analytics)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.title)
        }

        disclaimerTextView.withStyle(.nonEditable) {
            $0.text(€.Text.disclaimer)
        }

        hasReadDisclaimerCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.readDisclaimer)
        }

        declineButton.withStyle(.primary) {
            $0.title(€.Button.decline)
                .disabled()
        }

        acceptButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }

        buttonsStackView.withStyle(.horizontalFillingEqually)
    }
}
