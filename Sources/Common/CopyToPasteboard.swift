//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-27.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public func copyToPasteboard(contents: String) -> Bool {
	#if os(iOS)
	UIPasteboard.general.string = contents
	return true
#elseif os(macOS)
	NSPasteboard.general.clearContents()
	NSPasteboard.general.setString(contents, forType: .string)
	return true
	#else
	print("Unsupported platform, cannot copy to pasteboard.")
	return false
	#endif
}
