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

extension Reactive where Base: UITableView {
    var footerLabel: Binder<String> {
        Binder(base) { $0.setFooterLabel(text: $1) }
    }

    var itemSelected: AnyPublisher<IndexPath, Never> {
        guard let selectableTable = base as? SelectionPublishing else {
            assertionFailure("UITableView must adopt SelectionPublishing to use rx.itemSelected")
            return Empty().eraseToAnyPublisher()
        }
        return selectableTable.itemSelectedPublisher
    }
}

// Views that want rx.itemSelected must conform to this.
protocol SelectionPublishing: AnyObject {
    var itemSelectedPublisher: AnyPublisher<IndexPath, Never> { get }
}
