//
//  ImageAboveLabelButton.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class ImageAboveLabelButton: UIButton {
    private lazy var customLabel        = UILabel()
    private lazy var customImageView    = UIImageView()
    private lazy var stackView          = UIStackView(arrangedSubviews: [customImageView, customLabel])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    /// Make sure that we are not using the inbuilt label and imageview
    override func layoutSubviews() {
        super.layoutSubviews()
        assert(titleLabel?.text == nil, "You should not use the default `titleLabel`, but rather `customLabel` view")
        assert(imageView?.image == nil, "You should not use the default `titleLabel`, but rather `customLabel` view")
        assert(customLabel.text != nil, "call `setTitle:image`")
        assert(customImageView.image != nil, "call `setTitle:image`")
    }
}

// MARK: - Internal
extension ImageAboveLabelButton {
    func setTitle(_ title: String, image: UIImage) {
        customLabel.withStyle(
            .init(
                text: title,
                textAlignment: .center,
                textColor: .white,
                font: UIFont.callToAction,
                numberOfLines: 1,
                backgroundColor: .clear
            )
        )

        customImageView.withStyle(.default) {
            $0.image(image).contentMode(.center)
        }
    }
}

// MARK: - Accessibility
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

// MARK: - Private Setup
private extension ImageAboveLabelButton {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        withStyle(.primary) {
            $0.height(nil)
        }
        addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.withStyle(.default) {
            $0.layoutMargins(UIEdgeInsets(top: 30, bottom: 20)).spacing(30)
        }

        [stackView, customLabel, customImageView].forEach { $0.isUserInteractionEnabled = false }
    }
}

