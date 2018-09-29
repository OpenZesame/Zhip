//
//  MakeableCollectionViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-11.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//


import UIKit
import ViewComposer

private let cellId = "cellIdentifier"
final class MakeableCollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = [.dataSourceDelegate(self), .prefetchDataSource(self), .registerCells([CellClass(MyCollectionViewCell.self, cellId)]), .itemSize(CGSize(width: 80, height: 100)), .color(.white)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "ViewComposer - CollectionView"
    }
}

extension MakeableCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if let myCell = cell as? MyCollectionViewCell {
            myCell.configure(with: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath.section):\(indexPath.row)")
    }
}

extension MakeableCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("collectionView prefetching...")
    }
}

private extension MakeableCollectionViewController {
    func setupViews() {
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        collectionView.pinEdges(to: view)
    }
}
