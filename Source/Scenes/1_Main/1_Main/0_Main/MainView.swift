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

final class MainView: ScrollableStackViewOwner, PullToRefreshCapable {

    private lazy var motionEffectAuroraImageView    = UIView()
    private lazy var balanceTitleLabel              = UILabel()
    private lazy var balanceValueLabel              = UILabel()
    private lazy var zilliqaBalanceImageView        = UIImageView()
    private lazy var zilliqaImageVerticalPositioner = UIStackView(arrangedSubviews: [.spacer, zilliqaBalanceImageView, .spacer(height: 10)])
    private lazy var balanceValueAndIconStackView   = UIStackView(arrangedSubviews: [balanceValueLabel, zilliqaImageVerticalPositioner, .spacer])
    private lazy var balanceViews                   = UIStackView(arrangedSubviews: [balanceTitleLabel, balanceValueAndIconStackView])
    private lazy var sendButton                     = ImageAboveLabelButton()
    private lazy var receiveButton                  = ImageAboveLabelButton()
    private lazy var buttonsView                    = UIStackView(arrangedSubviews: [sendButton, receiveButton])

    lazy var stackViewStyle = UIStackView.Style([
        balanceViews,
        .spacer,
        buttonsView
        ], spacing: 8)

    override func setup() {
        setupSubviews()
    }
}

extension MainView: ViewModelled {
    typealias ViewModel = MainViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriverOnErrorReturnEmpty(),
            receiveTrigger: receiveButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: MainViewModel.Output) -> [Disposable] {
        return [
            viewModel.isFetchingBalance                 --> rx.isRefreshing,
            viewModel.balance                           --> balanceValueLabel.rx.text,
            viewModel.refreshControlLastUpdatedTitle    --> rx.pullToRefreshTitle
        ]
    }
}

private typealias € = L10n.Scene.Main
private extension MainView {

    // swiftlint:disable:next function_body_length
    func setupSubviews() {

        balanceTitleLabel.withStyle(.init(text: €.Label.Balance.title, textColor: UIColor.white.withAlphaComponent(0.7), font: .callToAction))

        balanceValueLabel.withStyle(.impression) {
            $0.font(.bigBang).minimumScaleFactor(0.5)
        }

        let zilliqaLogo = Asset.Icons.Small.zilliqaLogo.image.withRenderingMode(.alwaysOriginal)
        zilliqaBalanceImageView.withStyle(.init(image: zilliqaLogo, contentMode: UIView.ContentMode.bottomLeft))

        zilliqaImageVerticalPositioner.withStyle(.vertical) {
            $0.spacing(0)
        }

        balanceValueAndIconStackView.withStyle(.horizontal) {
            $0.spacing(4)
        }
        balanceViews.withStyle(.default) {
            $0.spacing(0)
        }

        sendButton.setTitle(€.Button.send, image: Asset.Icons.Large.send.image)
        receiveButton.setTitle(€.Button.receive, image: Asset.Icons.Large.receive.image)

        buttonsView.withStyle(.horizontal) {
            $0.distribution(.fillEqually)
        }

        buttonsView.height(184)

        insertSubview(motionEffectAuroraImageView, belowSubview: scrollView)
        motionEffectAuroraImageView.edgesToSuperview()
        setupAuroraImageViewWithMotionEffect()
    }

    func setupAuroraImageViewWithMotionEffect() {
        motionEffectAuroraImageView.backgroundColor = .clear
        motionEffectAuroraImageView.translatesAutoresizingMaskIntoConstraints = false

        motionEffectAuroraImageView.addMotionEffectFromImages(
            front: Asset.Images.Aurora.front.image, motionEffectStrength: 4,
            middle: Asset.Images.Aurora.background.image, motionEffectStrength: 10,
            back: Asset.Images.Aurora.background.image, motionEffectStrength: 20
        )
    }
}
