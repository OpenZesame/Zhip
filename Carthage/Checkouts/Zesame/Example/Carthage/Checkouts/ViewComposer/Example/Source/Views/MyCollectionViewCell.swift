//
//  MyCollectionViewCell.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-11.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

private let labelStyle: ViewStyle = [.textAlignment(.center)]
final class MyCollectionViewCell: UICollectionViewCell {
    lazy var sectionLabel: UILabel = labelStyle <<- [.color(.blue), .textColor(.red)]
    lazy var rowLabel: UILabel = labelStyle <<-  [.color(.red), .textColor(.blue)]
    lazy var stackView: StackView = [.views([self.sectionLabel, self.rowLabel]), .axis(.vertical)]^
    required init(coder: NSCoder) { fatalError("required init") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
}

extension MyCollectionViewCell: StackViewOwner {
    var parentView: UIView { return contentView }
}

extension MyCollectionViewCell {
    func configure(with indexPath: IndexPath) {
        sectionLabel.text = "Section: \(indexPath.section)"
        rowLabel.text = "Row: \(indexPath.row)"
    }
}

