//
//  PollTransactionStatusView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PollTransactionStatusView: ScrollableStackViewOwner {

	private lazy var backgroundImageView    			= UIImageView()
	private lazy var checkmarkLogoImageView				= UIImageView()
    private lazy var transactionBroadcastedLabel  		= UILabel()
    private lazy var mightTakeSomeMinutesLabel 		 	= UILabel()
    private lazy var seeTxDetailsWhenAvailableButton	= ButtonWithSpinner(mode: .nextToText)
    private lazy var skipWaitingOrDoneButton      		= UIButton()
	private lazy var topSpacer: UIView = .spacer
	private lazy var middleSpacer: UIView = .spacer

    lazy var stackViewStyle = UIStackView.Style([
		topSpacer,
		checkmarkLogoImageView,
		middleSpacer,
        transactionBroadcastedLabel,
        mightTakeSomeMinutesLabel,
        seeTxDetailsWhenAvailableButton,
		skipWaitingOrDoneButton
        ])

    override func setup() {
        setupSubviews()
    }
}

extension PollTransactionStatusView: ViewModelled {
    typealias ViewModel = PollTransactionStatusViewModel

	func populate(with viewModel: PollTransactionStatusViewModel.Output) -> [Disposable] {
		return [
			viewModel.skipWaitingOrDoneButtonTitle	-->	skipWaitingOrDoneButton.rx.title(for: .normal),
			viewModel.isSeeTxDetailsEnabled 		--> seeTxDetailsWhenAvailableButton.rx.isEnabled,
			viewModel.isSeeTxDetailsButtonLoading 	--> seeTxDetailsWhenAvailableButton.rx.isLoading
		]
	}

    var inputFromView: InputFromView {
        return InputFromView(
            skipWaitingOrDoneTrigger: skipWaitingOrDoneButton.rx.tap.asDriverOnErrorReturnEmpty(),
			seeTxDetails: seeTxDetailsWhenAvailableButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.PollTransactionStatus
private extension PollTransactionStatusView {
    func setupSubviews() {

		topSpacer.height(to: middleSpacer)

		checkmarkLogoImageView.withStyle(.default) {
			$0.image(Asset.Icons.Large.checkmark.image)
		}

        transactionBroadcastedLabel.withStyle(.header) {
            $0.text(€.Label.transactionBroadcasted).textAlignment(.center)
        }

		mightTakeSomeMinutesLabel.withStyle(.body) {
			$0.text(€.Label.mightTakeSomeMinutes).textAlignment(.center)
		}

        seeTxDetailsWhenAvailableButton.withStyle(.primary) {
            $0.title(€.Button.seeTransactionDetails)
        }

		skipWaitingOrDoneButton.withStyle(.secondary)

		backgroundImageView.withStyle(.background(image: Asset.Images.Spaceship.stars.image))
		
		insertSubview(backgroundImageView, belowSubview: scrollView)
    }
}
