//
//  ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-30.
//
//

import UIKit

public struct ViewStyle: Attributed {
    public typealias Attribute = ViewAttribute
    public typealias Element = ViewAttribute
    public static var mergeInterceptors: [MergeInterceptor.Type] = [ControlStateMerger.self]
    public static var duplicatesHandler: AnyDuplicatesHandler<ViewStyle>?
    public static var customStyler: AnyCustomStyler<ViewStyle>?
    
    public var startIndex: Int = 0
    
    public let attributes: [ViewAttribute]
    
    public init(attributes: [ViewAttribute]) {
        self.attributes = attributes
    }
}

public extension ViewStyle {
    //swiftlint:disable:next cyclomatic_complexity function_body_length
    func install(on styleable: Any) {
        defer { ViewStyle.customStyler?.customStyle(styleable, with: self) }
        guard let view = styleable as? UIView else { return }
        
        // Important to setup shared settings first, so that specific setting may override
        attributes.forEach {
            switch $0 {
            // All UIViews
            case .custom(let attributed):
                attributed.install(on: styleable)
            case .hidden(let isHidden):
                view.isHidden = isHidden
            case .layoutMargins(let margin):
                view.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
            case .color(let color):
                view.backgroundColor = color
            case .verticalHugging(let prio):
                view.setContentHuggingPriority(prio.value, for: .vertical)
            case .verticalCompression(let prio):
                view.setContentCompressionResistancePriority(prio.value, for: .vertical)
            case .horizontalHugging(let prio):
                view.setContentHuggingPriority(prio.value, for: .horizontal)
            case .horizontalCompression(let prio):
                view.setContentCompressionResistancePriority(prio.value, for: .horizontal)
            case .contentMode(let contentMode):
                view.contentMode = contentMode
            case .userInteractable(let isUserInteractionEnabled):
                view.isUserInteractionEnabled = isUserInteractionEnabled
            case .tintColor(let tintColor):
                view.tintColor = tintColor
            case .clipsToBounds(let clipsToBounds):
                view.clipsToBounds = clipsToBounds
            case .alpha(let alpha):
                view.alpha = alpha
            case .opaque(let isOpaque):
                view.isOpaque = isOpaque
            case .exclusiveTouch(let isExclusiveTouch):
                view.isExclusiveTouch = isExclusiveTouch
            case .multipleTouchEnabled(let isMultipleTouchEnabled):
                view.isMultipleTouchEnabled = isMultipleTouchEnabled
            case .clearsContextBeforeDrawing(let clearsContextBeforeDrawing):
                view.clearsContextBeforeDrawing = clearsContextBeforeDrawing
            case .semanticContentAttribute(let semantic):
                view.semanticContentAttribute = semantic
                
            // Layer
            case .cornerRadius(let radius):
                view.layer.cornerRadius = radius
                view.layer.masksToBounds = radius > 0
            case .borderWidth(let borderWidth):
                view.layer.borderWidth = borderWidth
            case .borderColor(let borderColor):
                view.layer.borderColor = borderColor.cgColor
            default:
                break
            }
        }
        
        if let textHolder = view as? TextHolder {
            textHolder.apply(self)
        }
        
        if let fontSizeAdjusting = view as? FontSizeAdjusting {
            fontSizeAdjusting.apply(self)
        }
        
        if let textInputting = view as? TextInputting {
            textInputting.apply(self)
        }
        
        if let imageHolder = view as? ImageHolder {
            imageHolder.apply(self)
        }
        
        if let imageViewRepresentable = view as? ImageViewRepresentable {
            imageViewRepresentable.apply(self)
        }
        
        if let placeholder = view as? PlaceholderOwner {
            placeholder.apply(self)
        }
        
        if let textInputTraitable = view as? TextInputTraitable {
            textInputTraitable.apply(self)
        }
        
        if let textField = view as? UITextField {
            textField.apply(self)
        }
        
        if let textView = view as? UITextView {
            textView.apply(self)
        }
        
        if let stackView = view as? UIStackView {
            stackView.apply(self)
        }
        
        if let scrollView = view as? UIScrollView {
            scrollView.applyToSuperclass(self)
        }
        
        if let collectionTableView = view as? CollectionTableView {
            collectionTableView.apply(self)
        }
        
        if let tableView = view as? UITableView {
            tableView.apply(self)
        }
        
        if let collectionView = view as? UICollectionView {
            collectionView.apply(self)
        }
        
        if let label = view as? UILabel {
            label.apply(self)
        }
        
        if let bar = view as? UISearchBar {
            bar.apply(self)
        }
        
        if let segmentedControl = view as? UISegmentedControl {
            segmentedControl.apply(self)
        }
  
        if let control = view as? UIControl {
            control.applyToSuperclass(self)
        }
        
        if let button = view as? UIButton {
            button.apply(self)
        }
        
        // Also handling case `dataSourceDelegate`
        if let delegateOwner = view as? DelegatesOwner {
            delegateOwner.apply(self)
        }
        
        // Also handling case `dataSourceDelegate`
        if let delegateOwner = view as? DataSourceOwner {
            delegateOwner.apply(self)
        }
        
        if let thumbTintColorOwner = view as? ThumbTintColorOwner {
            thumbTintColorOwner.apply(self)
        }
        
        if let slider = view as? UISlider {
            slider.apply(self)
        }
        
        if let `switch` = view as? UISwitch {
            `switch`.apply(self)
        }
        
        if let cellRegisterable = view as? CellRegisterable {
            cellRegisterable.apply(self)
        }
        
        if let webView = view as? WebView {
            webView.apply(self)
        }
        
        if let pageControl = view as? UIPageControl {
            pageControl.apply(self)
        }
        
        if let activityIndicatorView = view as? UIActivityIndicatorView {
            activityIndicatorView.apply(self)
        }
        
        if let progressView = view as? UIProgressView {
            progressView.apply(self)
        }
    }
}
