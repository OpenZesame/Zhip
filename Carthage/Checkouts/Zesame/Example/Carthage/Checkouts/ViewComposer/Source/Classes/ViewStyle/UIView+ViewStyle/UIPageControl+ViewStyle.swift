//
//  UIPageControl+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

internal extension UIPageControl {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .currentPage(let page):
                currentPage = page
            case .numberOfPages(let pageCount):
                numberOfPages = pageCount
            case .hidesForSinglePage(let hides):
                hidesForSinglePage = hides
            case .pageIndicatorTintColor(let color):
                pageIndicatorTintColor = color
            case .currentPageIndicatorTintColor(let color):
                currentPageIndicatorTintColor = color
            default:
                break
            }
        }
    }
}

