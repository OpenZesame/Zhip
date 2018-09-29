//
//  CellRegisterable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import UIKit

public protocol CellType {}
extension UITableViewCell: CellType {}
extension UICollectionViewCell: CellType {}

public protocol RegisterableCell {
    var identifier: String { get }
}

internal extension CellRegisterable {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .registerCells(let cells):
                registerCells(cells)
            default:
                break
            }
        }
    }
}

public struct CellClass: RegisterableCell {
    public let type: CellType.Type
    public let identifier: String
    
    public init<CellClazz: CellType>(_ type: CellClazz.Type, _ identifier: String) {
        self.type = type
        self.identifier = identifier
    }
}

public struct CellNib: RegisterableCell {
    
    public let nib: UINib
    public let identifier: String
    
    public init(_ nib: UINib, _ identifier: String) {
        self.nib = nib
        self.identifier = identifier
    }
}

public protocol CellRegisterable: class {
    func registerCells(_ cells: [RegisterableCell])

}

public protocol BaseCellRegisterable: class {
    associatedtype BaseCellType: CellType
    func registerClass(_ clazz: BaseCellType.Type?, identifier: String)
    func registerNib(_ nib: UINib?, identifier: String)
}

extension CellRegisterable where Self: BaseCellRegisterable {
    public func registerCells(_ cells: [RegisterableCell]) {
        let anyRegisterable = AnyCellRegisterable(self)
        for cell in cells {
            let cellIdentifier = cell.identifier
            if let cellClass = cell as? CellClass, let cellType = cellClass.type as? BaseCellType.Type {
                anyRegisterable.registerClass(cellType, identifier: cellIdentifier)
            } else if let cellNib = cell as? CellNib {
                anyRegisterable.registerNib(cellNib.nib, identifier: cellIdentifier)
            }
        }
    }
}

extension UITableView: CellRegisterable {}
extension UICollectionView: CellRegisterable {}

extension UITableView: BaseCellRegisterable {
    public typealias BaseCellType = UITableViewCell
    public func registerClass(_ clazz: BaseCellType.Type?, identifier: String) {
        self.register(clazz, forCellReuseIdentifier: identifier)
    }
    public func registerNib(_ nib: UINib?, identifier: String) {
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

extension UICollectionView: BaseCellRegisterable {
    public typealias BaseCellType = UICollectionViewCell
    public func registerClass(_ clazz: BaseCellType.Type?, identifier: String) {
        self.register(clazz, forCellWithReuseIdentifier: identifier)
    }
    public func registerNib(_ nib: UINib?, identifier: String) {
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

//swiftlint:disable generic_type_name
private class _AnyCellRegisterableBase<_BaseCellType: CellType>: BaseCellRegisterable {
    typealias BaseCellType = _BaseCellType
    init() {
        guard type(of: self) != _AnyCellRegisterableBase.self else {
            fatalError("_AnyCellRegisterableBase<BaseCellType> instances can not be created; create a subclass instance instead")
        }
    }
    
    func registerClass(_ clazz: BaseCellType.Type?, identifier: String) { abstractMethod() }
    func registerNib(_ nib: UINib?, identifier: String) { abstractMethod() }
}

private final class _AnyCellRegisterableBox<Concrete: BaseCellRegisterable>: _AnyCellRegisterableBase<Concrete.BaseCellType> {
    var concrete: Concrete
    
    init(_ concrete: Concrete) {
        self.concrete = concrete
    }
    
    override func registerClass(_ clazz: Concrete.BaseCellType.Type?, identifier: String) { concrete.registerClass(clazz, identifier: identifier) }
    override func registerNib(_ nib: UINib?, identifier: String) { concrete.registerNib(nib, identifier: identifier) }
}

final class AnyCellRegisterable<_BaseCellType: CellType>: BaseCellRegisterable {
    typealias BaseCellType = _BaseCellType
    private let box: _AnyCellRegisterableBase<BaseCellType>
    
    init<Concrete: BaseCellRegisterable>(_ concrete: Concrete) where Concrete.BaseCellType == BaseCellType {
        box = _AnyCellRegisterableBox(concrete)
    }
    
    func registerClass(_ clazz: BaseCellType.Type?, identifier: String) { box.registerClass(clazz, identifier: identifier) }
    func registerNib(_ nib: UINib?, identifier: String) { box.registerNib(nib, identifier: identifier) }
}

