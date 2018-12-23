//
//  AppAppearance.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class AppAppearance {
    static func setupDefault() {
        setupAppearance()
    }
}

// swiftlint:disable function_body_length
private func setupAppearance() {
    func setupBarButtonItemAppearance() {
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        let backImage = Asset.Icons.Small.chevronLeft.image
        let streched = backImage.stretchableImage(withLeftCapWidth: 15, topCapHeight: 30)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(streched, for: .normal, barMetrics: .default)
    }
    func setupNavigationBarAppearance() {
        func makeNavigationBarTransparent() {
            // Override point for customization after application launch.
            // Sets background to a blank/empty image
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            // Sets shadow (line below the bar) to a blank image
            UINavigationBar.appearance().shadowImage = UIImage()
            // Sets the translucent background color
            UINavigationBar.appearance().backgroundColor = .clear
            // Set translucent. (Default value is already true, so this can be removed if desired.)
            UINavigationBar.appearance().isTranslucent = true
        }

        makeNavigationBarTransparent()

        //To change Navigation Bar Background Color
        //        UINavigationBar.appearance().barTintColor = UIColor.blue
        //To change Back button title & icon color
        //        UINavigationBar.appearance().tintColor = .white
        //To change Navigation Bar Title Color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    setupNavigationBarAppearance()
    setupBarButtonItemAppearance()
}
