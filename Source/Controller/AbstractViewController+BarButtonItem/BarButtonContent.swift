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

struct BarButtonContent {
    enum ButtontType {
        case text(String)
        case image(UIImage)
        case system(UIBarButtonItem.SystemItem)
    }
    let type: ButtontType
    let style: UIBarButtonItem.Style?

    init(type: ButtontType, style: UIBarButtonItem.Style? = .plain) {
        self.type = type
        self.style = style
    }

    init(title: CustomStringConvertible, style: UIBarButtonItem.Style = .plain) {
        self.init(type: .text(title.description))
    }

    init(image: ImageConvertible, style: UIBarButtonItem.Style = .plain) {
        self.init(type: .image(image.image))
    }

    init(system: UIBarButtonItem.SystemItem) {
        self.init(type: .system(system))
    }
}

// MARK: - UIBarButtonItem
extension BarButtonContent {
    func makeBarButtonItem<Target>(target: Target, selector: Selector) -> UIBarButtonItem {
        switch type {
        case .image(let image): return UIBarButtonItem(image: image, style: style ?? .plain, target: target, action: selector)
        case .text(let text): return UIBarButtonItem(title: text, style: style ?? .plain, target: target, action: selector)
        case .system(let system): return UIBarButtonItem(barButtonSystemItem: system, target: target, action: selector)
        }
    }
}
