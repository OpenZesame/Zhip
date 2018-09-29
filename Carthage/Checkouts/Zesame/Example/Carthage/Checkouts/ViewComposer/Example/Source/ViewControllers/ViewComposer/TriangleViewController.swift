//
//  TriangleViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-02.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

class TriangleViewController: UIViewController, StackViewOwner {
    private lazy var triangleViewA: TriangleView = [.custom(TriangleViewStyle([.fillColor(.green), .fillStyle(.lowerAcute)])), .color(.red)]
    private lazy var triangleViewB: TriangleView = [.custom(TriangleViewStyle([.fillColor(.green), .fillStyle(.lowerGrave)]))]
    private lazy var triangleViewC: TriangleView = [.custom(TriangleViewStyle([.fillColor(.yellow)])), .color(.orange)]
    private lazy var triangleViewD = TriangleView([]) //using `default` ViewStyle in TriangleView
    
    lazy var stackView: UIStackView = [.views([self.triangleViewA, self.triangleViewB, self.triangleViewC, self.triangleViewD]), .axis(.vertical), .distribution(.fillEqually)]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "ViewComposer - TriangleView"
    }
}
