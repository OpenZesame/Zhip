//
//  SingleCellTypeTableView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class BaseTableViewOwner<Header, Cell>: AbstractSceneView where Cell: ListCell {
    let tableView: SingleCellTypeTableView<Header, Cell>

    // MARK: - Initialization
    init(style: UITableView.Style) {
        tableView = SingleCellTypeTableView(style: style)
        super.init(scrollView: tableView)
        setup()
    }
    
    // MARK: Overrideable
    func setup() { /* override me */ }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

protocol TableViewOwner {
    associatedtype Header
    associatedtype Cell: ListCell
    var tableView: SingleCellTypeTableView<Header, Cell> { get }
}

typealias ListCell = AbstractTableViewCell & CellConfigurable

typealias Sections<HeaderModel, CellModel> = (Observable<[SectionModel<HeaderModel, CellModel>]>) -> Disposable

//typealias HeaderlessTableView<Cell: ListCell> = SingleCellTypeTableView<Void, Cell>

class SingleCellTypeTableView<Header, Cell>: UITableView where Cell: ListCell {
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<Header, Cell.Model>>

    lazy var rxDataSource = DataSource(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
        if let typedCell = cell as? Cell {
            typedCell.configure(model: model)
        }
        return cell
    })

    lazy var sections: Sections<Header, Cell.Model> = rx.items(dataSource: rxDataSource)

    var cellDeselectionMode: CellDeselectionMode = .deselectCellsDirectly(animate: true)

    lazy var didSelectItem: Driver<IndexPath> = rx.itemSelected.asDriver().do(onNext: { [unowned self] indexPath in
        switch self.cellDeselectionMode {
        case .deselectCellsDirectly(let animated): self.deselectRow(at: indexPath, animated: animated)
        case .noImmediateDeselection: break
        }
    })

    // MARK: - Initialization
    init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

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

private extension SingleCellTypeTableView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        backgroundColor = .clear
        separatorStyle = .none
    }
}

extension SingleCellTypeTableView {
    enum CellDeselectionMode {
        case deselectCellsDirectly(animate: Bool)
        case noImmediateDeselection
    }
}

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
        label.withStyle(.init(textAlignment: .center, textColor: .silverGrey, font: .hint))

        contentView.addSubview(label)
        label.edgesToSuperview()
    }
}
