//
//  UITableView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import Foundation

internal extension UITableView {
    //swiftlint:disable:next cyclomatic_complexity function_body_length
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .sectionIndexMinimumDisplayRowCount(let rowCount):
                sectionIndexMinimumDisplayRowCount = rowCount
            case .sectionIndexTrackingBackgroundColor(let color):
                sectionIndexTrackingBackgroundColor = color
            case .sectionIndexBackgroundColor(let color):
                sectionIndexBackgroundColor = color
            case .sectionIndexColor(let color):
                sectionIndexColor = color
            case .rowHeight(let height):
                rowHeight = height
            case .separatorStyle(let separatorStyle):
                self.separatorStyle = separatorStyle
            case .separatorColor(let color):
                separatorColor = color
            case .separatorEffect(let effects):
                separatorEffect = effects
            case .separatorInset(let insets):
                separatorInset = insets
            case .cellLayoutMarginsFollowReadableWidth(let margin):
                cellLayoutMarginsFollowReadableWidth = margin
            case .sectionHeaderHeight(let height):
                sectionHeaderHeight = height
            case .sectionFooterHeight(let height):
                sectionFooterHeight = height
            case .estimatedRowHeight(let height):
                estimatedRowHeight = height
            case .estimatedSectionHeaderHeight(let height):
                estimatedSectionHeaderHeight = height
            case .estimatedSectionFooterHeight(let height):
                estimatedSectionFooterHeight = height
            case .allowsSelectionDuringEditing(let allowsSelection):
                allowsSelectionDuringEditing = allowsSelection
            case .allowsMultipleSelectionDuringEditing(let allowsSelection):
                allowsMultipleSelectionDuringEditing = allowsSelection
            case .isEditing(let isEditing):
                self.isEditing = isEditing
            default:
                break
            }
        }
    }
}
