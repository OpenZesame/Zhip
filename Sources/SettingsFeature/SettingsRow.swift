//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public extension Row {
	enum Action: Int, Hashable {
		// Section 0
		case removePincode, setPincode
		
		// Section 1
		case starUsOnGithub
		case reportIssueOnGithub
		
		// Section 2
		case acknowledgments
		case readTermsOfService
		
		// Section 3
		case backupWallet
		case removeWallet
		
#if DEBUG
		// Section 4
		case debugOnlyPurgeApp
#endif // DEBUG
	}
}

public struct Section: Equatable, Identifiable {
	public typealias ID = Array<Array<Row>>.Index
	public var id: ID { index }
	let index: ID
	let rows: [Row]
}

public struct Row: Equatable, Identifiable {
	public typealias ID = Action
	public var id: ID { action }
	
	let action: Action
	let title: String
	let icon: Image
	let isDestructive: Bool
	
	init(
		_ action: Action,
		title: String,
		icon: Image,
		isDestructive: Bool = false
	) {
		self.action = action
		self.title = title
		self.icon = icon
		self.isDestructive = isDestructive
	}
	
	init(
		_ action: Action,
		title: String,
		icon: String,
		isDestructive: Bool = false
	) {
		self.init(action, title: title, icon: Image(icon), isDestructive: isDestructive)
	}
	
	init(
		_ action: Action,
		title: String,
		iconSmall: String,
		isDestructive: Bool = false
	) {
		self.init(
			action,
			title: title,
			icon: "Icons/Small/\(iconSmall)",
			isDestructive: isDestructive
		)
	}
}


func makeSettingsChoicesSections(isPINSet: Bool) -> IdentifiedArrayOf<Section> {
	
	let removePINChoice = Row(
		.removePincode,
		title: "Remove pincode",
		iconSmall: "Delete",
		isDestructive: true
	)
	let setPINChoice = Row(
		.setPincode,
		title: "Set pincode",
		iconSmall: "PinCode"
	)
	
	var rowsMatrix: [[Row]] = [
		[
			isPINSet ? removePINChoice : setPINChoice
		],
		[
			.init(
				.starUsOnGithub,
				title: "Star us on Github (login required)",
				iconSmall: "GithubStar"
			),
			.init(
				.reportIssueOnGithub,
				title: "Report issue (Github login required)",
				iconSmall: "GithubIssue"
			),
			.init(
				.acknowledgments,
				title: "Acknowledgments",
				iconSmall: "Cup"
			),
			.init(
				.readTermsOfService,
				title: "Terms of service",
				iconSmall: "Document"
			)
		],
		[
			.init(
				.backupWallet,
				title: "Backup wallet",
				iconSmall: "BackUp"
			),
			.init(
				.removeWallet,
				title: "Remove wallet",
				iconSmall: "Delete",
				isDestructive: true
			)
		]
	]
	
	
#if DEBUG
	rowsMatrix.append(
		[
			Row(
				.debugOnlyPurgeApp,
				title: "Purge app 🧹",
				icon: Image(systemName: "exclamationmark.3"),
				isDestructive: true
			)
		]
	)
#endif // DEBUG
	
	let sections = rowsMatrix.enumerated().map {
		Section(index: $0.offset, rows: $0.element)
	}
	
	return IdentifiedArrayOf(uniqueElements: sections)
}
