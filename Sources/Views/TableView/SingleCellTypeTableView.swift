// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

typealias ListCell = AbstractTableViewCell & CellConfigurable

class SingleCellTypeTableView<Header, Cell: ListCell>: UITableView, UITableViewDelegate, UITableViewDataSource, SelectionPublishing {
    // MARK: - Data

    private var sectionModels: [SectionModel<Header, Cell.Model>] = [] {
        didSet { reloadData() }
    }

    /// Sink: bind a publisher of section models to reload the table.
    var sections: Binder<[SectionModel<Header, Cell.Model>]> {
        Binder(self) { $0.sectionModels = $1 }
    }

    // MARK: - Selection

    private let selectionSubject = PassthroughSubject<IndexPath, Never>()
    var selectionPublisher: AnyPublisher<IndexPath, Never> { selectionSubject.eraseToAnyPublisher() }

    var didSelectItem: AnyPublisher<IndexPath, Never> { selectionPublisher }

    var cellDeselectionMode: CellDeselectionMode = .deselectCellsDirectly(animate: true)

    // MARK: - Initialization

    init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        setup()
    }

    required init?(coder _: NSCoder) { interfaceBuilderSucks }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellDeselectionMode {
        case let .deselectCellsDirectly(animated): tableView.deselectRow(at: indexPath, animated: animated)
        case .noImmediateDeselection: break
        }
        selectionSubject.send(indexPath)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in _: UITableView) -> Int { sectionModels.count }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionModels[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
        if let typedCell = cell as? Cell {
            typedCell.configure(model: sectionModels[indexPath.section].items[indexPath.row])
        }
        return cell
    }
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
        dataSource = self
        delegate = self
    }
}

// MARK: - SectionModel

/// Minimal section model replacing RxDataSources.SectionModel.
struct SectionModel<Section, Item> {
    let model: Section
    let items: [Item]
}
