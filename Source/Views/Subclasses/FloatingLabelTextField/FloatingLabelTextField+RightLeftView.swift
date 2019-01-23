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
