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
