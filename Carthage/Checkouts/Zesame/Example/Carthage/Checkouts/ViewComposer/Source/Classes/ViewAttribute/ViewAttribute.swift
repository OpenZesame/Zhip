//
//  ViewAttribute.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public protocol MarginExpressible {
    var margin: Margin { get }
}

extension CGFloat: MarginExpressible {
    public var margin: Margin { return Margin(self) }
}

public struct Margin {
    let insets: UIEdgeInsets
    let isRelative: Bool
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, isRelative: Bool = true) {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.isRelative = isRelative
    }
    
    public init(_ all: CGFloat, isRelative: Bool = true) {
        self.init(top: all, left: all, bottom: all, right: all, isRelative: isRelative)
    }

    public init(vertical: CGFloat, horizontal: CGFloat, isRelative: Bool = true) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal, isRelative: isRelative)
    }
    
    public init(horizontal: CGFloat, isRelative: Bool = true) {
        self.init(vertical: 0, horizontal: horizontal, isRelative: isRelative)
    }
    
    public init(vertical: CGFloat, isRelative: Bool = true) {
        self.init(vertical: vertical, horizontal: 0, isRelative: isRelative)
    }
}

extension Margin: MarginExpressible {
    public var margin: Margin { return self }
}

public extension Margin {
    
    static func vertical(_ vertical: CGFloat) -> MarginExpressible {
        return Margin(vertical: vertical)
    }
    
    static func horizontal(_ horizontal: CGFloat) -> MarginExpressible {
        return Margin(horizontal: horizontal)
    }
}

//swiftlint:disable:next type_body_length
public enum ViewAttribute {
    
    //MARK: - Runtime attributes, not used inside of ViewComposer, you can use these inside runtime methods such as `layoutSubviews` and e.g. using `runtimeTextFieldInset` in the UITextFields method `placeholderRect:forBounds`
    case runtimePlaceholderColor(UIColor)
    case runtimePlaceholderFont(UIFont)
    case runtimeTextFieldInset(CGFloat)
    case runtimeTextFieldEdgeInset(CGFloat)
    
    case custom(BaseAttributed)
    case delegate(NSObjectProtocol?)
    case dataSource(NSObjectProtocol?)
    case dataSourceDelegate(NSObjectProtocol?)
    
    //MARK: - View
    case hidden(Bool)
    case color(UIColor)
    case verticalHugging(LayoutPriority)
    case verticalCompression(LayoutPriority)
    case horizontalHugging(LayoutPriority)
    case horizontalCompression(LayoutPriority)
    case contentMode(UIView.ContentMode)
    case height(CGFloat)
    case width(CGFloat)
    case layoutMargins(all: CGFloat)
    
    case userInteractable(Bool)
    case tintColor(UIColor)
    case clipsToBounds(Bool)
    case alpha(CGFloat)
    case opaque(Bool)
    case exclusiveTouch(Bool)
    case multipleTouchEnabled(Bool)
    case clearsContextBeforeDrawing(Bool)
    case semanticContentAttribute(UISemanticContentAttribute)
    
    //MARK: - UIView: Layer
    case cornerRadius(CGFloat) /* might be overridden by: */; case roundedBy(CornerRounding)
    case borderWidth(CGFloat)
    case borderColor(UIColor)
    
    //MARK: - TextHolder
    case text(String?)
    case font(UIFont)
    case textColor(UIColor)
    case `case`(Case)
    case textAlignment(NSTextAlignment)
    
    //MAKR: - FontSizeAdjusting (UILabel + UITextField)
    case adjustsFontSizeToFitWidth(Bool)
    
    //MARK: - PlaceholderOwner
    case placeholder(String)
    
    //MARK: - TextInputting (UITextField + UITextView)
    case editable(Bool)
    case clearsOnInsertion(Bool)
    case clearsOnBeginEditing(Bool)
    case inputView(UIView?)
    case inputAccessoryView(UIView?)
    case allowsEditingTextAttributes(Bool)
    case dataDetectorTypes(UIDataDetectorTypes)
    case typingAttributes([NSAttributedString.Key: Any]?)
    
    //MARK: - UILabel
    case numberOfLines(Int)
    case highlightedTextColor(UIColor)
    case minimumScaleFactor(CGFloat)
    case baselineAdjustment(UIBaselineAdjustment)
    case shadowColor(UIColor)
    case shadowOffset(CGSize)
    case attributedText(NSAttributedString)
    
    //MARK: UITextInputTraits (UITextField & UISearchBar & UITextView)
    case autocapitalizationType(UITextAutocapitalizationType)
    case autocorrectionType(UITextAutocorrectionType)
    case spellCheckingType(UITextSpellCheckingType)
    case keyboardType(UIKeyboardType)
    case keyboardAppearance(UIKeyboardAppearance)
    case returnKeyType(UIReturnKeyType)
    case enablesReturnKeyAutomatically(Bool)
    case isSecureTextEntry(Bool)
    case textContentType(UITextContentType)
    
    //MARK: UITextField
    case borderStyle(UITextField.BorderStyle)
    case background(UIImage?)
    case disabledBackground(UIImage?)
    case clearButtonMode(UITextField.ViewMode)
    case leftView(UIView?)
    case leftViewMode(UITextField.ViewMode)
    case rightView(UIView?)
    case rightViewMode(UITextField.ViewMode)
    
    //MARK: - UITextView
    case selectedRange(NSRange)
    case linkTextAttributes([NSAttributedString.Key: Any]?)
    case textContainerInset(UIEdgeInsets)
    
    //MARK: - ImageHolder
    case image(UIImage?)
    case highlightedImage(UIImage?)
    case renderingMode(UIImage.RenderingMode)
    case animationImages([UIImage]?)
    case highlightedAnimationImages([UIImage]?)
    case animationRepeatCount(Int)
    case animationDuration(TimeInterval)
    
    //MARK: - UIScrollView
    case scrollEnabled(Bool)
    case contentSize(CGSize)
    case contentInset(UIEdgeInsets)
    case bounces(Bool)
    case alwaysBounceVertical(Bool)
    case alwaysBounceHorizontal(Bool)
    case pagingEnabled(Bool)
    case showsHorizontalScrollIndicator(Bool)
    case showsVerticalScrollIndicator(Bool)
    case scrollIndicatorInsets(UIEdgeInsets)
    case indicatorStyle(UIScrollView.IndicatorStyle)
    case decelerationRate(UIScrollView.DecelerationRate)
    case delaysContentTouches(Bool)
    case canCancelContentTouches(Bool)
    case minimumZoomScale(CGFloat)
    case maximumZoomScale(CGFloat)
    case zoomScale(CGFloat)
    case bouncesZoom(Bool)
    case scrollsToTop(Bool)
    case keyboardDismissMode(UIScrollView.KeyboardDismissMode)
    
    //MARK: - UIControl
    case states([ControlStateStyle])
    case contentVerticalAlignment(UIControl.ContentVerticalAlignment)
    case contentHorizontalAlignment(UIControl.ContentHorizontalAlignment)
    case targets([Actor])
    public static func target(_ actor: Actor) -> ViewAttribute {
        return .targets([actor])
    }
    case enabled(Bool)
    case selected(Bool)
    case highlighted(Bool)
    
    //MARK: - UIButton
    case contentEdgeInsets(UIEdgeInsets)
    case titleEdgeInsets(UIEdgeInsets)
    case reversesTitleShadowWhenHighlighted(Bool)
    case imageEdgeInsets(UIEdgeInsets)
    case adjustsImageWhenHighlighted(Bool)
    case adjustsImageWhenDisabled(Bool)
    case showsTouchWhenHighlighted(Bool)
    
    //MARK: - UIStackView
    case axis(NSLayoutConstraint.Axis)
    case distribution(UIStackView.Distribution)
    case alignment(UIStackView.Alignment)
    case spacing(CGFloat)
    case margin(MarginExpressible)
    public static func horizontalMargin(_ horizontal: CGFloat) -> ViewAttribute {
        return .margin(Margin.horizontal(horizontal))
    }
    public static func verticalMargin(_ vertical: CGFloat) -> ViewAttribute {
        return .margin(Margin.vertical(vertical))
    }
    case marginsRelative(Bool)
    case baselineRelative(Bool)
    case views([UIView?])
    
    //MARK: - CellRegisterable
    case registerCells([RegisterableCell])
    
    //MARK: CollectionTableView
    case backgroundView(UIView?)
    case allowsMultipleSelection(Bool)
    case allowsSelection(Bool)
    case remembersLastFocusedIndexPath(Bool)
    case prefetchDataSource(NSObjectProtocol?)
    
    //MARK: - UITableView
    case sectionIndexMinimumDisplayRowCount(Int)
    case sectionIndexTrackingBackgroundColor(UIColor?)
    case sectionIndexBackgroundColor(UIColor)
    case sectionIndexColor(UIColor)
    case rowHeight(CGFloat)
    case separatorStyle(UITableViewCell.SeparatorStyle)
    case separatorColor(UIColor?)
    case separatorEffect(UIVisualEffect?)
    case separatorInset(UIEdgeInsets)
    case cellLayoutMarginsFollowReadableWidth(Bool)
    case sectionHeaderHeight(CGFloat)
    case sectionFooterHeight(CGFloat)
    case estimatedRowHeight(CGFloat)
    case estimatedSectionHeaderHeight(CGFloat)
    case estimatedSectionFooterHeight(CGFloat)
    case allowsSelectionDuringEditing(Bool)
    case allowsMultipleSelectionDuringEditing(Bool)
    case isEditing(Bool)
    
    //MARK: - UICollectionView
    case collectionViewLayout(UICollectionViewLayout)
    case itemSize(CGSize)
    case isPrefetchingEnabled(Bool)
    
    //MARK: - UISearchBar
    case prompt(String)
    case searchBarStyle(UISearchBar.Style)
    
    //MARK: - UISegmentedControl
    case segments([SegmentContent])
    
    //MARK: ThumbTintColorOwner (UISwitch and UISlider)
    case thumbTintColor(UIColor?)
    
    //MARK: - UISwitch
    case on(Bool)
    case onTintColor(UIColor?)
    case onImage(UIImage?)
    case offImge(UIImage?)
    
    //MARK: WebView
    case webPage(URLRequest)

    //MARK: - UISlider
    case sliderValue(Double)
    case sliderRange(Range<Double>)
    
    //MARK: - UIActivityIndicatorView
    case spin(Bool)
    case hidesWhenStopped(Bool)
    case spinnerStyle(UIActivityIndicatorView.Style)
    case spinnerScale(CGFloat)
    
    //MARK: - UIProgressView
    case progressViewStyle(UIProgressView.Style)
    case progress(Float)
    case progressTintColor(UIColor?)
    case progressImage(UIImage?)
    case trackTintColor(UIColor?)
    case trackImage(UIImage?)
    
    //MARK: - UIPageControl
    case currentPage(Int)
    case numberOfPages(Int)
    case hidesForSinglePage(Bool)
    case pageIndicatorTintColor(UIColor)
    case currentPageIndicatorTintColor(UIColor)
}
