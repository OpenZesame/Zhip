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
private let acceptDeclineButtonsHeight: CGFloat = 60

final class AskForAnalyticsPermissionsView: ScrollingStackView {

    private lazy var topImageView = UIImageView()
    private lazy var topImageViewContainerStackView = UIStackView.Style([topImageView], alignment: .center).make()

    private lazy var titleLabel = UILabel.Style(€.title, font: .boldSystemFont(ofSize: 20)).make()

    private lazy var disclaimerTextView = UITextView.Style(€.Text.disclaimer, textAlignment: .left, font: .systemFont(ofSize: 17), textColor: .lightGray, isEditable: false).make()

    private lazy var readDisclaimerSwitch = UISwitch()
    private lazy var readDisclaimerLabel = UILabel.Style(€.SwitchLabel.readDisclaimer).make()
    private lazy var readDisclaimerStackView = UIStackView.Style([readDisclaimerSwitch, readDisclaimerLabel], axis: .horizontal, margin: 0).make()

    private lazy var declineButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.decline)
        .disabled()
    
    private lazy var acceptButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.accept)
        .disabled()
    
    private lazy var buttonsStackView = UIStackView.Style([declineButton, acceptButton], axis: .horizontal, distribution: .fillEqually).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        topImageViewContainerStackView,
        titleLabel,
        disclaimerTextView,
        readDisclaimerStackView,
        buttonsStackView
    ])

    override func setup() {
        topImageView.backgroundColor = .lightGray
        topImageView.clipsToBounds = true
        topImageView.size(CGSize(width: topImageViewWidthHeight, height: topImageViewWidthHeight))
        topImageView.layer.cornerRadius = topImageViewWidthHeight / 2
        titleLabel.textAlignment = .center
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
            readDisclaimerTrigger: readDisclaimerSwitch.rx.isOn.asDriver(),
            acceptTrigger: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            declineTrigger: declineButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}
