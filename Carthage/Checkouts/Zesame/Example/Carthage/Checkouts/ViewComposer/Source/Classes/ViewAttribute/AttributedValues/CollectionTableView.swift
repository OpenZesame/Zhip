//
//  CollectionTableView.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import Foundation

public protocol CollectionTableView: class {
    var allowsMultipleSelection: Bool { get set }
    var allowsSelection: Bool { get set }
    var remembersLastFocusedIndexPath: Bool { get set }
    var backgroundView: UIView? { get set }
    var anyPrefetchDataSource: NSObjectProtocol? { get set }
}

extension UICollectionView: CollectionTableView {
    public var anyPrefetchDataSource: NSObjectProtocol? {
        get {
            guard #available(iOS 10.0, *) else { return nil }
            return prefetchDataSource
        }
        
        set {
            guard #available(iOS 10.0, *) else { return  }
            guard let newValue = newValue else { prefetchDataSource = nil; return }
            guard let casted = newValue as? UICollectionViewDataSourcePrefetching else { return}
            prefetchDataSource = casted
        }
    }
}

extension UITableView: CollectionTableView {
    public var anyPrefetchDataSource: NSObjectProtocol? {
        get {
            guard #available(iOS 10.0, *) else { return nil }
            return prefetchDataSource
        }
        
        set {
            guard #available(iOS 10.0, *) else { return  }
            guard let newValue = newValue else { prefetchDataSource = nil; return }
            guard let casted = newValue as? UITableViewDataSourcePrefetching else { return}
            prefetchDataSource = casted
        }
    }
}

internal extension CollectionTableView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .backgroundView(let view):
                backgroundView = view
            case .allowsMultipleSelection(let allowSelection):
                allowsMultipleSelection = allowSelection
            case .allowsSelection(let allowSelection):
                allowsSelection = allowSelection
            case .remembersLastFocusedIndexPath(let remembers):
                remembersLastFocusedIndexPath = remembers
            case .prefetchDataSource(let dataSource):
                anyPrefetchDataSource = dataSource
            default:
                break
            }
        }
    }
}
