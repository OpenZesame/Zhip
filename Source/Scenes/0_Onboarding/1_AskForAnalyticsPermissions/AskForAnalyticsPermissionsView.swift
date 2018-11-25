//
//  AskForAnalyticsPermissionsView.swift
//  Zupreme
//
//  Created by Andrei Radulescu on 09/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

private typealias € = L10n.Scene.AskForAnalyticsPermissions

private let topImageViewWidthHeight: CGFloat = 80

final class AskForAnalyticsPermissionsView: ScrollingStackView {

    private lazy var topImageView = UIImageView()

    private lazy var topImageViewContainerStackView = UIStackView(arrangedSubviews: [topImageView])
        .withStyle(.default) { customizableStyle in
            customizableStyle.alignment(.center)
    }

    private lazy var titleLabel = UILabel(text: €.title).withStyle(.title)

    private lazy var disclaimerTextView = UITextView(text: €.Text.disclaimer).withStyle(.nonEditable)

    private lazy var readDisclaimerSwitch = UISwitch()
    private lazy var readDisclaimerLabel = UILabel(text: €.SwitchLabel.readDisclaimer).withStyle(.checkbox)

    private lazy var readDisclaimerStackView = UIStackView(arrangedSubviews: [readDisclaimerSwitch, readDisclaimerLabel]).withStyle(.horizontal)

    private lazy var declineButton = UIButton(title: €.Button.decline)
        .withStyle(.primary)
        .disabled()

    private lazy var acceptButton = UIButton(title: €.Button.accept)
        .withStyle(.primary)
        .disabled()

    private lazy var buttonsStackView = UIStackView(arrangedSubviews: [declineButton, acceptButton])
        .withStyle(.horizontalFillingEqually)

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        topImageViewContainerStackView,
        titleLabel,
        disclaimerTextView,
        readDisclaimerStackView,
        buttonsStackView
    ]

    override func setup() {
        topImageView.backgroundColor = .lightGray
        topImageView.clipsToBounds = true
        topImageView.size(CGSize(width: topImageViewWidthHeight, height: topImageViewWidthHeight))
        topImageView.layer.cornerRadius = topImageViewWidthHeight / 2
    }
}

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
            haveReadDisclaimerTrigger: readDisclaimerSwitch.rx.isOn.asDriver(),
            acceptTrigger: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            declineTrigger: declineButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}
