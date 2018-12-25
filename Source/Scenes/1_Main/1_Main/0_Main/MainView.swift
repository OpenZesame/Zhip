//
//  MainView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageAboveLabelButton: UIButton {
    private lazy var customLabel = UILabel()
    private lazy var customImageView = UIImageView()
    private lazy var stackView = UIStackView(arrangedSubviews: [customImageView, customLabel])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        assert(titleLabel?.text == nil, "You should not use the default `titleLabel`, but rather `customLabel` view")
        assert(imageView?.image == nil, "You should not use the default `titleLabel`, but rather `customLabel` view")
        assert(customLabel.text != nil, "call `setTitle:image`")
        assert(customImageView.image != nil, "call `setTitle:image`")
    }

    func setTitle(_ title: String, image: UIImage) {
        customLabel.withStyle(
            .init(
                text: title,
                textAlignment: .center,
                font: UIFont.callToAction,
                textColor: .white,
                numberOfLines: 1,
                backgroundColor: .clear
            )
        )

        customImageView.withStyle(.default) {
            $0.image(image).contentMode(.center)
        }
    }
}

private extension ImageAboveLabelButton {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        withStyle(.primary)
        addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.withStyle(.default) {
            $0.layoutMargins(UIEdgeInsets(top: 30, bottom: 20)).spacing(30)
        }
    }
}

extension ImageAboveLabelButton {
    override var accessibilityLabel: String? {
        get { return customLabel.accessibilityLabel }
        set { customLabel.accessibilityLabel = newValue }
    }

    override var accessibilityHint: String? {
        get { return customLabel.accessibilityHint }
        set { customLabel.accessibilityHint = newValue }
    }

    override var accessibilityValue: String? {
        get { return customLabel.accessibilityValue }
        set { customLabel.accessibilityValue = newValue }
    }
}

private extension MainView {
    func setupSubviews() {

        balanceTitleLabel.withStyle(.title) {
            $0.text(€.Label.Balance.title)
        }

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
        balanceViews.withStyle(.default)

        sendButton.setTitle(€.Button.send, image: Asset.Icons.Large.send.image)
        receiveButton.setTitle(€.Button.receive, image: Asset.Icons.Large.receive.image)

        buttonsView.withStyle(.horizontal) {
            $0.distribution(.fillEqually)
        }

        buttonsView.height(184)

        insertSubview(motionEffectAuroraImageView, belowSubview: stackView)
        motionEffectAuroraImageView.edgesToSuperview()
        setupAuroraImageViewWithMotionEffect()
    }
}

final class MainView: ScrollingStackView, PullToRefreshCapable {

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
            viewModel.isFetchingBalance     --> rx.isRefreshing,
            viewModel.balance               --> balanceValueLabel.rx.text
        ]
    }
}

private typealias € = L10n.Scene.Main
private extension MainView {

    func setupAuroraImageViewWithMotionEffect() {
        motionEffectAuroraImageView.backgroundColor = .clear
        motionEffectAuroraImageView.translatesAutoresizingMaskIntoConstraints = false

        motionEffectAuroraImageView.addMotionEffectFromImageAssets(
            front: Asset.Images.Aurora.front,
            // TODO add new middle
            middle: Asset.Images.Aurora.background,
            back: Asset.Images.Aurora.background
        )
    }
}
