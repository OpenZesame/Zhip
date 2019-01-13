//
//  FloatingLabelTextField+RightLeftView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

extension FloatingLabelTextField {
    enum Position {
        case right, left
    }

    func addBottomAlignedButton(asset: ImageAsset, position: Position = .right, offset: CGFloat = 0, mode: UITextField.ViewMode = .always) -> UIButton {
        return addBottomAlignedButton(image: asset.image, position: position, offset: offset, mode: mode)
    }

    func addBottomAlignedButton(image: UIImage, position: Position = .right, offset: CGFloat = 0, mode: UITextField.ViewMode = .always) -> UIButton {
        return addBottomAlignedButton(imageOrText: .image(image), position: position, offset: offset, mode: mode)
    }

    func addBottomAlignedButton(titled: String, position: Position = .right, offset: CGFloat = 0, mode: UITextField.ViewMode = .always) -> UIButton {
        return addBottomAlignedButton(imageOrText: .text(titled), position: position, offset: offset, mode: mode)
    }

    private func addBottomAlignedButton(imageOrText: ImageOrText, position: Position = .right, offset: CGFloat = 0, mode: UITextField.ViewMode = .always) -> UIButton {
        let button = UIButton()
        var width: CGFloat?
        switch imageOrText {
        case .image(let image):
            button.withStyle(.image(image))
            width = image.size.width
        case .text(let title):
            button.withStyle(.title(title))
            width = button.widthOfTitle()
        }

        button.setContentHuggingPriority(.required, for: .vertical)

        addBottomAligned(view: button, position: position, width: width, offset: offset, mode: mode)

        return button
    }

    func addBottomAligned(view: UIView, position: Position = .right, width: CGFloat? = nil, offset: CGFloat = 0, mode: UITextField.ViewMode = .always) {
        view.translatesAutoresizingMaskIntoConstraints = true
        let bottomAligningContainerView = UIView()
        let width = width ?? FloatingLabelTextField.rightViewWidth
        let height: CGFloat = 40
        let offset: CGFloat = 0
        let y: CGFloat = FloatingLabelTextField.textFieldHeight - height - offset
        view.frame = CGRect(x: 0, y: y, width: width, height: height)
        bottomAligningContainerView.addSubview(view)

        switch position {
        case .left:
            leftView = bottomAligningContainerView
            leftViewMode = mode
        case .right:
            rightView = bottomAligningContainerView
            rightViewMode = mode
        }
    }
}
