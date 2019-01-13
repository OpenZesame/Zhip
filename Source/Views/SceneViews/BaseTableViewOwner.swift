//
//  BaseTableViewOwner.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

typealias TableViewSceneView<Header, Cell: ListCell> = BaseTableViewOwner<Header, Cell> & TableViewOwner

typealias HeaderlessTableViewSceneView<Cell: ListCell> = TableViewSceneView<Void, Cell>

class BaseTableViewOwner<Header, Cell>: AbstractSceneView where Cell: ListCell {

    let tableView: SingleCellTypeTableView<Header, Cell>

    // MARK: - Initialization
    init(style: UITableView.Style) {
        tableView = SingleCellTypeTableView(style: style)
        super.init(scrollView: tableView)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}
