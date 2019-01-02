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

typealias ListCell = UITableViewCell & CellConfigurable

typealias Sections<HeaderModel, CellModel> = (Observable<[SectionModel<HeaderModel, CellModel>]>) -> Disposable

typealias HeaderlessTableView<Cell: ListCell> = SingleCellTypeTableView<Void, Cell>

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

private extension SingleCellTypeTableView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        backgroundColor = .white
        separatorStyle = .none
    }
}

extension SingleCellTypeTableView {
    enum CellDeselectionMode {
        case deselectCellsDirectly(animate: Bool)
        case noImmediateDeselection
    }
}

