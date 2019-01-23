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
import RxSwift
import RxCocoa

final class PollTransactionStatusView: ScrollableStackViewOwner {

	private lazy var backgroundImageView    			= UIImageView()
	private lazy var checkmarkLogoImageView				= UIImageView()
    private lazy var transactionBroadcastedLabel  		= UILabel()
    private lazy var mightTakeSomeMinutesLabel 		 	= UILabel()
    private lazy var seeTxDetailsWhenAvailableButton	= ButtonWithSpinner(mode: .nextToText)
    private lazy var skipWaitingOrDoneButton      		= UIButton()

    lazy var stackViewStyle = UIStackView.Style([
		checkmarkLogoImageView,
        .spacer,
        transactionBroadcastedLabel,
        mightTakeSomeMinutesLabel,
        seeTxDetailsWhenAvailableButton,
		skipWaitingOrDoneButton
        ], layoutMargins: UIEdgeInsets(top: 50, bottom: 0))

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
