//
//  TableViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-02.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

private let cellId = "cellIdentifier"
final class TableViewController: UIViewController {
    fileprivate let models = makeModels()
    lazy var tableView: UITableView = [.dataSourceDelegate(self), .registerCells([CellClass(UITableViewCell.self, cellId)]), .prefetchDataSource(self)]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}
extension TableViewController: SingleSubviewOwner { var subview: UITableView { return tableView } }

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = titleForRow(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < 1 ? "Comparison" : "ViewComposer only"
    }
}

extension TableViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("tableView prefetching...")
    }
}

private extension TableViewController {
    func didSelectRow(at indexPath: IndexPath) {
        model(at: indexPath).push(onto: navigationController)
    }
    
    func model(at indexPath: IndexPath) -> Model {
        return models[indexPath.section][indexPath.row]
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        return model(at: indexPath).title
    }
}

func makeModels() -> [[Model]] {
    let both = [
        Model("Nested StackViews", type: NestedStackViewsViewController.self, vanilla: VanillaNestedStackViewsViewController.self),
        Model("Labels", type: LabelsViewController.self, vanilla: VanillaLabelsViewController.self),
        Model("LoginViewController", type: LoginViewController.self, vanilla: VanillaLoginViewController.self),
    ]
    
    let viewComposerOnly = [
        Model("Custom attribute: FooLabel (simple)", type: SimpleCustomAttributeViewController.self),
        Model("Custom attribute: TriangleView (advanced)", type: TriangleViewController.self),
        Model("Mixed Views", type: MixedViewsViewController.self),
        Model("CollectionView", type: MakeableCollectionViewController.self),
        Model("WKWebView", type: MakeableWKWebViewViewController.self),
        Model("ImageView", type: ImageViewController.self)
    ]
    return [both, viewComposerOnly]
}
