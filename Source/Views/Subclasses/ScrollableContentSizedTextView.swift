//
//  ScrollableContentSizedTextView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class ScrollableContentSizedTextView: UITextView {

    init() {
        super.init(frame: .zero, textContainer: nil)
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

