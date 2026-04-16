//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import RxCocoa
import RxSwift
import UIKit

// MARK: - SettingsView

final class SettingsView: HeaderlessTableViewSceneView<SettingsTableViewCell> {
    init() {
        super.init(style: .grouped)
    }

    required init?(coder _: NSCoder) {
        interfaceBuilderSucks
    }

    override func setup() {
        tableView.contentInset = UIEdgeInsets(top: 0, bottom: 30)
    }
}

extension SettingsView: ViewModelled {
    typealias ViewModel = SettingsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        [
            viewModel.sections.drive(tableView.sections),
            viewModel.footerText.drive(tableView.rx.footerLabel),
        ]
    }

    var inputFromView: InputFromView {
        InputFromView(
            selectedIndexPath: tableView.rx.itemSelected.asDriver()
        )
    }
}
