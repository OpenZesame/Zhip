//
//  UICollectionView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UICollectionView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .itemSize(let itemSize):
                guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { break }
                flowLayout.itemSize = itemSize
            case .collectionViewLayout(let layout):
                collectionViewLayout = layout
            case .isPrefetchingEnabled(let enabled):
                guard #available(iOS 10.0, *) else { return }
                isPrefetchingEnabled = enabled
            default:
                break
            }
        }
    }
}
