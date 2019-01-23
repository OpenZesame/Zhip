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

final class FooterView: UITableViewHeaderFooterView {

    private lazy var label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension FooterView {
    func updateLabel(text: String) {
        label.text = text
    }
}

private extension FooterView {
    func setup() {
        label.withStyle(.init(textAlignment: .center, textColor: .silverGrey, font: .hint, numberOfLines: 2))

        contentView.addSubview(label)
        label.edgesToSuperview()
    }
}

