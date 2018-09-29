//
//  ImageViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-09-05.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import Foundation
import ViewComposer

private let imageSize: CGFloat = 300
let imageStyle: ViewStyle = [.image(#imageLiteral(resourceName: "white")), .highlightedImage(#imageLiteral(resourceName: "red")), .height(imageSize), .width(imageSize), .contentMode(.scaleAspectFit)]
final class ImageViewController: UIViewController, StackViewOwner {
    
    lazy var imageView: UIImageView = imageStyle <<- .highlighted(true)
    
    lazy var button: UIButton = imageStyle <<- .target(self.target(#selector(pressed)))

    var views: [UIView] { return [imageView, button] }
    lazy var stackView: UIStackView = .axis(.vertical) <- .views(self.views)
        <- [.spacing(20), .spacing(10), .distribution(.fillProportionally)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "ViewComposer - ImageViewController"
    }
}

private extension ImageViewController {
    
    @objc func pressed() {
        print("pressed")
    }
}
