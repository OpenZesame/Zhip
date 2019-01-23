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
import RxDataSources
import RxSwift
import RxCocoa

typealias ListCell = AbstractTableViewCell & CellConfigurable

typealias Sections<HeaderModel, CellModel> = (Observable<[SectionModel<HeaderModel, CellModel>]>) -> Disposable

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

// MARK: - CellDeselectionMode
extension SingleCellTypeTableView {
    enum CellDeselectionMode {
        case deselectCellsDirectly(animate: Bool)
        case noImmediateDeselection
    }
}

// MARK: - Private
private extension SingleCellTypeTableView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        backgroundColor = .clear
        separatorStyle = .none
    }
}
