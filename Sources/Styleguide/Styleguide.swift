//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-08.
//

import SwiftUI

public enum Styleguide {}
public extension Styleguide {
	static func install() {
#if os(iOS)
		install_iOSStyles()
#endif
	}
}

#if os(iOS)
private extension Styleguide {
	static func install_iOSStyles() {
		// For NavigationBarTitle with Large Font
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

		// For NavigationBarTitle with `displayMode = .inline`
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
	}
}
#endif
