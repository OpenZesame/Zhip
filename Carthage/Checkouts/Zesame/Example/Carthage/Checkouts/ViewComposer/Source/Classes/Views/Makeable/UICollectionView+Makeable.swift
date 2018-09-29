//
//  UICollectionView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

extension UICollectionView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
}
