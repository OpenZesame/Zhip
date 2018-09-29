//
//  UIScrollView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UIScrollView {
    //swiftlint:disable:next cyclomatic_complexity function_body_length
    func applyToSuperclass(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .scrollEnabled(let isScrollEnabled):
                self.isScrollEnabled = isScrollEnabled
            case .contentSize(let contentSize):
                self.contentSize = contentSize
            case .contentInset(let contentInset):
                self.contentInset = contentInset
            case .bounces(let bounces):
                self.bounces = bounces
            case .alwaysBounceVertical(let bounce):
                self.alwaysBounceVertical = bounce
            case .alwaysBounceHorizontal(let bounce):
                self.alwaysBounceHorizontal = bounce
            case .pagingEnabled(let enabled):
                self.isPagingEnabled = enabled
            case .showsHorizontalScrollIndicator(let show):
                self.showsHorizontalScrollIndicator = show
            case .showsVerticalScrollIndicator(let show):
                self.showsVerticalScrollIndicator = show
            case .indicatorStyle(let style):
                self.indicatorStyle = style
            case .decelerationRate(let rate):
                self.decelerationRate = rate
            case .delaysContentTouches(let delay):
                self.delaysContentTouches = delay
            case .canCancelContentTouches(let canCancel):
                self.canCancelContentTouches = canCancel
            case .minimumZoomScale(let zoomScale):
                self.minimumZoomScale = zoomScale
            case .maximumZoomScale(let zoomScale):
                self.maximumZoomScale = zoomScale
            case .bouncesZoom(let zoom):
                self.bouncesZoom = zoom
            case .scrollsToTop(let scrolls):
                self.scrollsToTop = scrolls
            case .keyboardDismissMode(let dismissMode):
                self.keyboardDismissMode = dismissMode
            default:
                break
            }
        }
    }
}
