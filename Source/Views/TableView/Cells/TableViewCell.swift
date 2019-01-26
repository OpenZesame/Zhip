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

class AbstractTableViewCell: UITableViewCell {

    fileprivate lazy var customLabel = UILabel()
    fileprivate lazy var customImageView = UIImageView()
    fileprivate lazy var stackView = UIStackView(arrangedSubviews: [customImageView, customLabel])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

private extension AbstractTableViewCell {
    func setup() {
        backgroundColor = .clear
        selectionStyle = .default

        // Note that we should call `customLabel.withStyle(model.labelStyle)`
        // and `customImageView.withStyle(model.imageViewStyle)` inside `configure:model`
        stackView.withStyle(.horizontal) {
            $0.distribution(.fillProportionally)
                .layoutMargins(UIEdgeInsets(vertical: 0, horizontal: 16))
        }

        contentView.addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.height(56)
    }
}

class TableViewCell<Model: CellModel>: AbstractTableViewCell, CellConfigurable {}

extension CellConfigurable where Self: AbstractTableViewCell, Model: CellModel {
    func configure(model: Model) {
        customLabel.withStyle(model.labelStyle)
        customImageView.withStyle(model.imageViewStyle)
        accessoryType = model.accessoryType
    }
}
