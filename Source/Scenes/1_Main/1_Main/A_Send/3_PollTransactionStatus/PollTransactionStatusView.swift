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
import RxSwift
import RxCocoa

final class PollTransactionStatusView: ScrollableStackViewOwner {

    private lazy var motionEffectStarsImageView         = UIView()
	private lazy var checkmarkLogoImageView				= UIImageView()
    private lazy var transactionBroadcastedLabel  		= UILabel()
    private lazy var mightTakeSomeMinutesLabel 		 	= UILabel()
    private lazy var copyTransactionIdButton            = UIButton()
    private lazy var seeTxDetailsWhenAvailableButton    = ButtonWithSpinner(mode: .nextToText)
    private lazy var skipWaitingOrDoneButton            = UIButton()

    lazy var stackViewStyle = UIStackView.Style([
		checkmarkLogoImageView,
        .spacer,
        transactionBroadcastedLabel,
        mightTakeSomeMinutesLabel,
        copyTransactionIdButton,
        seeTxDetailsWhenAvailableButton,
		skipWaitingOrDoneButton
        ], layoutMargins: UIEdgeInsets(top: 50, left: 16, bottom: 0, right: 16))

    override func setup() {
        setupSubviews()
    }
}

extension PollTransactionStatusView: ViewModelled {
    typealias ViewModel = PollTransactionStatusViewModel

	func populate(with viewModel: PollTransactionStatusViewModel.Output) -> [Disposable] {
		return [
            viewModel.skipWaitingOrDoneButtonTitle    -->    skipWaitingOrDoneButton.rx.title(for: .normal),
            viewModel.isSeeTxDetailsEnabled         --> seeTxDetailsWhenAvailableButton.rx.isEnabled,
            viewModel.isSeeTxDetailsButtonLoading     --> seeTxDetailsWhenAvailableButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyTransactionIdTrigger: copyTransactionIdButton.rx.tap.asDriverOnErrorReturnEmpty(),
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

        copyTransactionIdButton.withStyle(.secondary) {
            $0.title(€.Button.copyTransactionId)
        }

        seeTxDetailsWhenAvailableButton.withStyle(.primary) {
            $0.title(€.Button.seeTransactionDetails)
        }

		skipWaitingOrDoneButton.withStyle(.secondary)

        insertSubview(motionEffectStarsImageView, belowSubview: scrollView)
        motionEffectStarsImageView.edgesToSuperview()
        setupStarsImageWithMotionEffect()
    }

    func setupStarsImageWithMotionEffect() {
        motionEffectStarsImageView.backgroundColor = .clear
        motionEffectStarsImageView.translatesAutoresizingMaskIntoConstraints = false

        let stars = Asset.Images.ChooseWallet.middleStars.image
        let starsVerticallyFlipped = stars.withVerticallyFlippedOrientation(yOffset: -stars.size.height/2)
        let starsHorizontallyFlipped = stars.withHorizontallyFlippedOrientation()

        motionEffectStarsImageView.addMotionEffectFromImages(
            front: stars,
            middle: starsVerticallyFlipped,
            back: starsHorizontallyFlipped
        )
    }
}
