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

final class RefreshControl: UIRefreshControl {
    private lazy var spinner = SpinnerView()
    private lazy var label = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [spinner, label])

    override init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    // Ugly hack to remove default spinner: https://stackoverflow.com/a/33472020/1311272
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        // setting `isHidden = true` does not work
        subviews.first?.alpha = 0
    }
}

extension RefreshControl {
    func setTitle(_ title: String) {
        label.text = title
    }
}

private extension RefreshControl {
    func setup() {
        backgroundColor = .clear
        contentMode = .scaleToFill
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.withStyle(.init(textAlignment: .center, textColor: .white, font: .title))
        stackView.withStyle(.vertical) {
            $0.distribution(.fill).spacing(0)
        }
        addSubview(stackView)
        spinner.height(30, priority: .defaultHigh)
        stackView.edgesToSuperview()
        spinner.startSpinning()
        setTitle(L10n.View.PullToRefreshControl.title)
    }
}
