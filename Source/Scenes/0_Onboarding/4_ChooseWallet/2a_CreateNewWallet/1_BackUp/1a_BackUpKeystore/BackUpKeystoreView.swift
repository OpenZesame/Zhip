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

final class BackUpKeystoreView: ScrollableStackViewOwner {

    private lazy var keystoreTextView   = UITextView()
    private lazy var copyButton         = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        copyButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackUpKeystoreView: ViewModelled {
    typealias ViewModel = BackUpKeystoreViewModel

    func populate(with viewModel: BackUpKeystoreViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystore --> keystoreTextView.rx.text
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyTrigger: copyButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.BackUpKeystore
private extension BackUpKeystoreView {
    func setupSubviews() {
        keystoreTextView.withStyle(.nonEditable) {
            $0.textAlignment(.left)
        }

        copyButton.withStyle(.primary) {
            $0.title(€.Button.copy)
        }
    }
}
