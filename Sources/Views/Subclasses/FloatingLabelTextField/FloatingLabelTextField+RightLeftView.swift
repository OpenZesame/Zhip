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
