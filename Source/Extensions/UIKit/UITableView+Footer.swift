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

import RxSwift
import RxCocoa

extension UITableView {
    func setFooterLabel(text: String, height: CGFloat = 44) {
        let footerView: FooterView

        if let tableFooterView = tableFooterView as? FooterView {
            footerView = tableFooterView
        } else {
            footerView = FooterView()
            let fittingSize = CGSize(width: bounds.width - (safeAreaInsets.left + safeAreaInsets.right), height: 0)
            let size = footerView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            footerView.frame = CGRect(x: 0, y: 0, width: size.width, height: height)

            tableFooterView = footerView
        }

        footerView.updateLabel(text: text)
    }
}

extension Reactive where Base: UITableView {
    var footerLabel: Binder<String> {
        return Binder<String>(base) {
            $0.setFooterLabel(text: $1)
        }
    }
}
