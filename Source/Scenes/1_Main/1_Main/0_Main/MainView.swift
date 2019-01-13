//
//  MainView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
        motionEffectAuroraImageView.edgesToParent(topToSafeArea: true, bottomToSafeArea: true)
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
