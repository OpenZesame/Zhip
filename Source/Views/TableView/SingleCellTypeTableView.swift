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
