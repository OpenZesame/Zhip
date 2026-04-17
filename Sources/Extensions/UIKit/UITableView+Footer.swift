// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

extension UITableView {
    func setFooterLabel(text: String, height: CGFloat = 44) {
        let footerView: FooterView

        if let tableFooterView = tableFooterView as? FooterView {
            footerView = tableFooterView
        } else {
            footerView = FooterView()
            let fittingSize = CGSize(width: bounds.width - (safeAreaInsets.left + safeAreaInsets.right), height: 0)
            let size = footerView.systemLayoutSizeFitting(
                fittingSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            footerView.frame = CGRect(x: 0, y: 0, width: size.width, height: height)
            tableFooterView = footerView
        }

        footerView.updateLabel(text: text)
    }
}

extension UITableView {
    var footerLabelBinder: Binder<String> {
        Binder(self) { $0.setFooterLabel(text: $1) }
    }

    var itemSelectedPublisher: AnyPublisher<IndexPath, Never> {
        guard let selectableTable = self as? SelectionPublishing else {
            assertionFailure("UITableView must adopt SelectionPublishing to expose itemSelectedPublisher")
            return Empty().eraseToAnyPublisher()
        }
        return selectableTable.selectionPublisher
    }
}

// Views that want itemSelectedPublisher must conform to this.
protocol SelectionPublishing: AnyObject {
    var selectionPublisher: AnyPublisher<IndexPath, Never> { get }
}
