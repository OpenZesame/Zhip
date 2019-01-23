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

