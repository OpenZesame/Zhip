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
    private let hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    private var player: AVAudioPlayer?

    private lazy var motionEffectStarsImageViewWithGradient = GradientView()
	private lazy var checkmarkLogoImageView				    = UIImageView()
    private lazy var transactionBroadcastedLabel  		    = UILabel()
    private lazy var mightTakeSomeMinutesLabel 		 	    = UILabel()
    private lazy var copyTransactionIdButton                = UIButton()
    private lazy var seeTxDetailsWhenAvailableButton        = ButtonWithSpinner(mode: .nextToText)
    private lazy var skipWaitingOrDoneButton                = UIButton()

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
        
        let vibrateSuccessTrigger = viewModel.isSeeTxDetailsEnabled
        
		return [
            viewModel.skipWaitingOrDoneButtonTitle    -->    skipWaitingOrDoneButton.rx.title(for: .normal),
            viewModel.isSeeTxDetailsEnabled         --> seeTxDetailsWhenAvailableButton.rx.isEnabled,
            viewModel.isSeeTxDetailsButtonLoading     --> seeTxDetailsWhenAvailableButton.rx.isLoading,
            vibrateSuccessTrigger.drive(onNext: { [weak self] finishedPolling in
                if !finishedPolling {
                    self?.playSound()
                }
                self?.vibrate()
            })
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

        insertSubview(motionEffectStarsImageViewWithGradient, belowSubview: scrollView)
        motionEffectStarsImageViewWithGradient.edgesToSuperview()
        addStarsImagesWithMotionEffect(to: motionEffectStarsImageViewWithGradient)
    }

    func addStarsImagesWithMotionEffect(to view: UIView) {
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        let stars = Asset.Images.ChooseWallet.middleStars.image
        let starsVerticallyFlipped = stars.withVerticallyFlippedOrientation(yOffset: -stars.size.height/2)
        let starsHorizontallyFlipped = stars.withHorizontallyFlippedOrientation()

        view.addMotionEffectFromImages(
            front: stars,
            middle: starsVerticallyFlipped,
            back: starsHorizontallyFlipped
        )
    }
    
    func vibrate() {
        vibrateOnValid(hapticFeedbackGenerator: hapticFeedbackGenerator)
    }
}

import AVFoundation
private extension PollTransactionStatusView {
    
    // https://stackoverflow.com/a/32036291/1311272
    func playSound() {

        // Sound found here: https://freesound.org/people/MATTIX/sounds/445723/
        guard let url = Bundle.main.url(forResource: "freesound_mattix_radar", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
