//
//  Scene.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol BackgroundColorSpecifying {
    static var colorOfBackground: UIColor { get }
}
extension BackgroundColorSpecifying {
    static var colorOfBackground: UIColor { return .deepBlue }
    var colorOfBackground: UIColor { return Self.colorOfBackground }
}

typealias ContentView = UIView & ViewModelled

/// Use typealias when you don't require a subclass. If your use case requires subclass, inherit from `SceneController`.
typealias Scene<View: ContentView> = SceneController<View> & TitledScene where View.ViewModel.Input.FromController == InputFromController

