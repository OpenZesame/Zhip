// Generated using Sourcery 0.12.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT




extension StrippedRepresentation where Self.RawValue: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func >(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }

    public static func >=(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }

    public static func <=(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension AssociatedValueStrippable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.stripped < rhs.stripped
    }

    public static func >(lhs: Self, rhs: Self) -> Bool {
        return lhs.stripped > rhs.stripped
    }

    public static func >=(lhs: Self, rhs: Self) -> Bool {
        return lhs.stripped >= rhs.stripped
    }

    public static func <=(lhs: Self, rhs: Self) -> Bool {
        return lhs.stripped <= rhs.stripped
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.stripped == rhs.stripped
    }
}

public extension AssociatedValueEnumExtractor {
    func associatedValueTyped<T>() -> T? {
        if let value = associatedValue as? T {
            return value
        } else if let recursive = associatedValue as? AssociatedValueEnumExtractor, let value = recursive.associatedValue as? T {
            return value
        } 
        return nil
    }
}

public extension Collection where Iterator.Element: AssociatedValueStrippable, Iterator.Element: Hashable {
    func contains(_ element: Iterator.Element.Stripped) -> Bool {
        return map { $0.stripped }.contains(element)
    }
}

public extension Collection where Iterator.Element: AssociatedValueStrippable, Iterator.Element: AssociatedValueEnumExtractor {
    func associatedValue<AssociatedValue>(_ element: Iterator.Element.Stripped) -> AssociatedValue? {
        for item in self {
            guard item.stripped == element else { continue }
            return item.associatedValueTyped()
        }
        return nil
    }
}

extension ViewAttribute: AssociatedValueEnumExtractor {
    public var associatedValue: Any? {
        switch self {
            case .runtimePlaceholderColor(let runtimePlaceholderColor):
                return runtimePlaceholderColor
            case .runtimePlaceholderFont(let runtimePlaceholderFont):
                return runtimePlaceholderFont
            case .runtimeTextFieldInset(let runtimeTextFieldInset):
                return runtimeTextFieldInset
            case .runtimeTextFieldEdgeInset(let runtimeTextFieldEdgeInset):
                return runtimeTextFieldEdgeInset
            case .custom(let custom):
                return custom
            case .delegate(let delegate):
                return delegate
            case .dataSource(let dataSource):
                return dataSource
            case .dataSourceDelegate(let dataSourceDelegate):
                return dataSourceDelegate
            case .hidden(let hidden):
                return hidden
            case .color(let color):
                return color
            case .verticalHugging(let verticalHugging):
                return verticalHugging
            case .verticalCompression(let verticalCompression):
                return verticalCompression
            case .horizontalHugging(let horizontalHugging):
                return horizontalHugging
            case .horizontalCompression(let horizontalCompression):
                return horizontalCompression
            case .contentMode(let contentMode):
                return contentMode
            case .height(let height):
                return height
            case .width(let width):
                return width
            case .layoutMargins(let layoutMargins):
                return layoutMargins
            case .userInteractable(let userInteractable):
                return userInteractable
            case .tintColor(let tintColor):
                return tintColor
            case .clipsToBounds(let clipsToBounds):
                return clipsToBounds
            case .alpha(let alpha):
                return alpha
            case .opaque(let opaque):
                return opaque
            case .exclusiveTouch(let exclusiveTouch):
                return exclusiveTouch
            case .multipleTouchEnabled(let multipleTouchEnabled):
                return multipleTouchEnabled
            case .clearsContextBeforeDrawing(let clearsContextBeforeDrawing):
                return clearsContextBeforeDrawing
            case .semanticContentAttribute(let semanticContentAttribute):
                return semanticContentAttribute
            case .cornerRadius(let cornerRadius):
                return cornerRadius
            case .roundedBy(let roundedBy):
                return roundedBy
            case .borderWidth(let borderWidth):
                return borderWidth
            case .borderColor(let borderColor):
                return borderColor
            case .text(let text):
                return text
            case .font(let font):
                return font
            case .textColor(let textColor):
                return textColor
            case .`case`(let `case`):
                return `case`
            case .textAlignment(let textAlignment):
                return textAlignment
            case .adjustsFontSizeToFitWidth(let adjustsFontSizeToFitWidth):
                return adjustsFontSizeToFitWidth
            case .placeholder(let placeholder):
                return placeholder
            case .editable(let editable):
                return editable
            case .clearsOnInsertion(let clearsOnInsertion):
                return clearsOnInsertion
            case .clearsOnBeginEditing(let clearsOnBeginEditing):
                return clearsOnBeginEditing
            case .inputView(let inputView):
                return inputView
            case .inputAccessoryView(let inputAccessoryView):
                return inputAccessoryView
            case .allowsEditingTextAttributes(let allowsEditingTextAttributes):
                return allowsEditingTextAttributes
            case .dataDetectorTypes(let dataDetectorTypes):
                return dataDetectorTypes
            case .typingAttributes(let typingAttributes):
                return typingAttributes
            case .numberOfLines(let numberOfLines):
                return numberOfLines
            case .highlightedTextColor(let highlightedTextColor):
                return highlightedTextColor
            case .minimumScaleFactor(let minimumScaleFactor):
                return minimumScaleFactor
            case .baselineAdjustment(let baselineAdjustment):
                return baselineAdjustment
            case .shadowColor(let shadowColor):
                return shadowColor
            case .shadowOffset(let shadowOffset):
                return shadowOffset
            case .attributedText(let attributedText):
                return attributedText
            case .autocapitalizationType(let autocapitalizationType):
                return autocapitalizationType
            case .autocorrectionType(let autocorrectionType):
                return autocorrectionType
            case .spellCheckingType(let spellCheckingType):
                return spellCheckingType
            case .keyboardType(let keyboardType):
                return keyboardType
            case .keyboardAppearance(let keyboardAppearance):
                return keyboardAppearance
            case .returnKeyType(let returnKeyType):
                return returnKeyType
            case .enablesReturnKeyAutomatically(let enablesReturnKeyAutomatically):
                return enablesReturnKeyAutomatically
            case .isSecureTextEntry(let isSecureTextEntry):
                return isSecureTextEntry
            case .textContentType(let textContentType):
                return textContentType
            case .borderStyle(let borderStyle):
                return borderStyle
            case .background(let background):
                return background
            case .disabledBackground(let disabledBackground):
                return disabledBackground
            case .clearButtonMode(let clearButtonMode):
                return clearButtonMode
            case .leftView(let leftView):
                return leftView
            case .leftViewMode(let leftViewMode):
                return leftViewMode
            case .rightView(let rightView):
                return rightView
            case .rightViewMode(let rightViewMode):
                return rightViewMode
            case .selectedRange(let selectedRange):
                return selectedRange
            case .linkTextAttributes(let linkTextAttributes):
                return linkTextAttributes
            case .textContainerInset(let textContainerInset):
                return textContainerInset
            case .image(let image):
                return image
            case .highlightedImage(let highlightedImage):
                return highlightedImage
            case .renderingMode(let renderingMode):
                return renderingMode
            case .animationImages(let animationImages):
                return animationImages
            case .highlightedAnimationImages(let highlightedAnimationImages):
                return highlightedAnimationImages
            case .animationRepeatCount(let animationRepeatCount):
                return animationRepeatCount
            case .animationDuration(let animationDuration):
                return animationDuration
            case .scrollEnabled(let scrollEnabled):
                return scrollEnabled
            case .contentSize(let contentSize):
                return contentSize
            case .contentInset(let contentInset):
                return contentInset
            case .bounces(let bounces):
                return bounces
            case .alwaysBounceVertical(let alwaysBounceVertical):
                return alwaysBounceVertical
            case .alwaysBounceHorizontal(let alwaysBounceHorizontal):
                return alwaysBounceHorizontal
            case .pagingEnabled(let pagingEnabled):
                return pagingEnabled
            case .showsHorizontalScrollIndicator(let showsHorizontalScrollIndicator):
                return showsHorizontalScrollIndicator
            case .showsVerticalScrollIndicator(let showsVerticalScrollIndicator):
                return showsVerticalScrollIndicator
            case .scrollIndicatorInsets(let scrollIndicatorInsets):
                return scrollIndicatorInsets
            case .indicatorStyle(let indicatorStyle):
                return indicatorStyle
            case .decelerationRate(let decelerationRate):
                return decelerationRate
            case .delaysContentTouches(let delaysContentTouches):
                return delaysContentTouches
            case .canCancelContentTouches(let canCancelContentTouches):
                return canCancelContentTouches
            case .minimumZoomScale(let minimumZoomScale):
                return minimumZoomScale
            case .maximumZoomScale(let maximumZoomScale):
                return maximumZoomScale
            case .zoomScale(let zoomScale):
                return zoomScale
            case .bouncesZoom(let bouncesZoom):
                return bouncesZoom
            case .scrollsToTop(let scrollsToTop):
                return scrollsToTop
            case .keyboardDismissMode(let keyboardDismissMode):
                return keyboardDismissMode
            case .states(let states):
                return states
            case .contentVerticalAlignment(let contentVerticalAlignment):
                return contentVerticalAlignment
            case .contentHorizontalAlignment(let contentHorizontalAlignment):
                return contentHorizontalAlignment
            case .targets(let targets):
                return targets
            case .enabled(let enabled):
                return enabled
            case .selected(let selected):
                return selected
            case .highlighted(let highlighted):
                return highlighted
            case .contentEdgeInsets(let contentEdgeInsets):
                return contentEdgeInsets
            case .titleEdgeInsets(let titleEdgeInsets):
                return titleEdgeInsets
            case .reversesTitleShadowWhenHighlighted(let reversesTitleShadowWhenHighlighted):
                return reversesTitleShadowWhenHighlighted
            case .imageEdgeInsets(let imageEdgeInsets):
                return imageEdgeInsets
            case .adjustsImageWhenHighlighted(let adjustsImageWhenHighlighted):
                return adjustsImageWhenHighlighted
            case .adjustsImageWhenDisabled(let adjustsImageWhenDisabled):
                return adjustsImageWhenDisabled
            case .showsTouchWhenHighlighted(let showsTouchWhenHighlighted):
                return showsTouchWhenHighlighted
            case .axis(let axis):
                return axis
            case .distribution(let distribution):
                return distribution
            case .alignment(let alignment):
                return alignment
            case .spacing(let spacing):
                return spacing
            case .margin(let margin):
                return margin
            case .marginsRelative(let marginsRelative):
                return marginsRelative
            case .baselineRelative(let baselineRelative):
                return baselineRelative
            case .views(let views):
                return views
            case .registerCells(let registerCells):
                return registerCells
            case .backgroundView(let backgroundView):
                return backgroundView
            case .allowsMultipleSelection(let allowsMultipleSelection):
                return allowsMultipleSelection
            case .allowsSelection(let allowsSelection):
                return allowsSelection
            case .remembersLastFocusedIndexPath(let remembersLastFocusedIndexPath):
                return remembersLastFocusedIndexPath
            case .prefetchDataSource(let prefetchDataSource):
                return prefetchDataSource
            case .sectionIndexMinimumDisplayRowCount(let sectionIndexMinimumDisplayRowCount):
                return sectionIndexMinimumDisplayRowCount
            case .sectionIndexTrackingBackgroundColor(let sectionIndexTrackingBackgroundColor):
                return sectionIndexTrackingBackgroundColor
            case .sectionIndexBackgroundColor(let sectionIndexBackgroundColor):
                return sectionIndexBackgroundColor
            case .sectionIndexColor(let sectionIndexColor):
                return sectionIndexColor
            case .rowHeight(let rowHeight):
                return rowHeight
            case .separatorStyle(let separatorStyle):
                return separatorStyle
            case .separatorColor(let separatorColor):
                return separatorColor
            case .separatorEffect(let separatorEffect):
                return separatorEffect
            case .separatorInset(let separatorInset):
                return separatorInset
            case .cellLayoutMarginsFollowReadableWidth(let cellLayoutMarginsFollowReadableWidth):
                return cellLayoutMarginsFollowReadableWidth
            case .sectionHeaderHeight(let sectionHeaderHeight):
                return sectionHeaderHeight
            case .sectionFooterHeight(let sectionFooterHeight):
                return sectionFooterHeight
            case .estimatedRowHeight(let estimatedRowHeight):
                return estimatedRowHeight
            case .estimatedSectionHeaderHeight(let estimatedSectionHeaderHeight):
                return estimatedSectionHeaderHeight
            case .estimatedSectionFooterHeight(let estimatedSectionFooterHeight):
                return estimatedSectionFooterHeight
            case .allowsSelectionDuringEditing(let allowsSelectionDuringEditing):
                return allowsSelectionDuringEditing
            case .allowsMultipleSelectionDuringEditing(let allowsMultipleSelectionDuringEditing):
                return allowsMultipleSelectionDuringEditing
            case .isEditing(let isEditing):
                return isEditing
            case .collectionViewLayout(let collectionViewLayout):
                return collectionViewLayout
            case .itemSize(let itemSize):
                return itemSize
            case .isPrefetchingEnabled(let isPrefetchingEnabled):
                return isPrefetchingEnabled
            case .prompt(let prompt):
                return prompt
            case .searchBarStyle(let searchBarStyle):
                return searchBarStyle
            case .segments(let segments):
                return segments
            case .thumbTintColor(let thumbTintColor):
                return thumbTintColor
            case .on(let on):
                return on
            case .onTintColor(let onTintColor):
                return onTintColor
            case .onImage(let onImage):
                return onImage
            case .offImge(let offImge):
                return offImge
            case .webPage(let webPage):
                return webPage
            case .sliderValue(let sliderValue):
                return sliderValue
            case .sliderRange(let sliderRange):
                return sliderRange
            case .spin(let spin):
                return spin
            case .hidesWhenStopped(let hidesWhenStopped):
                return hidesWhenStopped
            case .spinnerStyle(let spinnerStyle):
                return spinnerStyle
            case .spinnerScale(let spinnerScale):
                return spinnerScale
            case .progressViewStyle(let progressViewStyle):
                return progressViewStyle
            case .progress(let progress):
                return progress
            case .progressTintColor(let progressTintColor):
                return progressTintColor
            case .progressImage(let progressImage):
                return progressImage
            case .trackTintColor(let trackTintColor):
                return trackTintColor
            case .trackImage(let trackImage):
                return trackImage
            case .currentPage(let currentPage):
                return currentPage
            case .numberOfPages(let numberOfPages):
                return numberOfPages
            case .hidesForSinglePage(let hidesForSinglePage):
                return hidesForSinglePage
            case .pageIndicatorTintColor(let pageIndicatorTintColor):
                return pageIndicatorTintColor
            case .currentPageIndicatorTintColor(let currentPageIndicatorTintColor):
                return currentPageIndicatorTintColor
        }
    }

    var runtimePlaceholderColor: UIColor? {
        switch self {
            case .runtimePlaceholderColor(let runtimePlaceholderColor):
                return runtimePlaceholderColor
            default: return nil
        }
    }

    var runtimePlaceholderFont: UIFont? {
        switch self {
            case .runtimePlaceholderFont(let runtimePlaceholderFont):
                return runtimePlaceholderFont
            default: return nil
        }
    }

    var runtimeTextFieldInset: CGFloat? {
        switch self {
            case .runtimeTextFieldInset(let runtimeTextFieldInset):
                return runtimeTextFieldInset
            default: return nil
        }
    }

    var runtimeTextFieldEdgeInset: CGFloat? {
        switch self {
            case .runtimeTextFieldEdgeInset(let runtimeTextFieldEdgeInset):
                return runtimeTextFieldEdgeInset
            default: return nil
        }
    }

    var custom: BaseAttributed? {
        switch self {
            case .custom(let custom):
                return custom
            default: return nil
        }
    }

    var delegate: NSObjectProtocol? {
        switch self {
            case .delegate(let delegate):
                return delegate
            default: return nil
        }
    }

    var dataSource: NSObjectProtocol? {
        switch self {
            case .dataSource(let dataSource):
                return dataSource
            default: return nil
        }
    }

    var dataSourceDelegate: NSObjectProtocol? {
        switch self {
            case .dataSourceDelegate(let dataSourceDelegate):
                return dataSourceDelegate
            default: return nil
        }
    }

    var hidden: Bool? {
        switch self {
            case .hidden(let hidden):
                return hidden
            default: return nil
        }
    }

    var color: UIColor? {
        switch self {
            case .color(let color):
                return color
            default: return nil
        }
    }

    var verticalHugging: LayoutPriority? {
        switch self {
            case .verticalHugging(let verticalHugging):
                return verticalHugging
            default: return nil
        }
    }

    var verticalCompression: LayoutPriority? {
        switch self {
            case .verticalCompression(let verticalCompression):
                return verticalCompression
            default: return nil
        }
    }

    var horizontalHugging: LayoutPriority? {
        switch self {
            case .horizontalHugging(let horizontalHugging):
                return horizontalHugging
            default: return nil
        }
    }

    var horizontalCompression: LayoutPriority? {
        switch self {
            case .horizontalCompression(let horizontalCompression):
                return horizontalCompression
            default: return nil
        }
    }

    var contentMode: UIView.ContentMode? {
        switch self {
            case .contentMode(let contentMode):
                return contentMode
            default: return nil
        }
    }

    var height: CGFloat? {
        switch self {
            case .height(let height):
                return height
            default: return nil
        }
    }

    var width: CGFloat? {
        switch self {
            case .width(let width):
                return width
            default: return nil
        }
    }

    var layoutMargins: CGFloat? {
        switch self {
            case .layoutMargins(let layoutMargins):
                return layoutMargins
            default: return nil
        }
    }

    var userInteractable: Bool? {
        switch self {
            case .userInteractable(let userInteractable):
                return userInteractable
            default: return nil
        }
    }

    var tintColor: UIColor? {
        switch self {
            case .tintColor(let tintColor):
                return tintColor
            default: return nil
        }
    }

    var clipsToBounds: Bool? {
        switch self {
            case .clipsToBounds(let clipsToBounds):
                return clipsToBounds
            default: return nil
        }
    }

    var alpha: CGFloat? {
        switch self {
            case .alpha(let alpha):
                return alpha
            default: return nil
        }
    }

    var opaque: Bool? {
        switch self {
            case .opaque(let opaque):
                return opaque
            default: return nil
        }
    }

    var exclusiveTouch: Bool? {
        switch self {
            case .exclusiveTouch(let exclusiveTouch):
                return exclusiveTouch
            default: return nil
        }
    }

    var multipleTouchEnabled: Bool? {
        switch self {
            case .multipleTouchEnabled(let multipleTouchEnabled):
                return multipleTouchEnabled
            default: return nil
        }
    }

    var clearsContextBeforeDrawing: Bool? {
        switch self {
            case .clearsContextBeforeDrawing(let clearsContextBeforeDrawing):
                return clearsContextBeforeDrawing
            default: return nil
        }
    }

    var semanticContentAttribute: UISemanticContentAttribute? {
        switch self {
            case .semanticContentAttribute(let semanticContentAttribute):
                return semanticContentAttribute
            default: return nil
        }
    }

    var cornerRadius: CGFloat? {
        switch self {
            case .cornerRadius(let cornerRadius):
                return cornerRadius
            default: return nil
        }
    }

    var roundedBy: CornerRounding? {
        switch self {
            case .roundedBy(let roundedBy):
                return roundedBy
            default: return nil
        }
    }

    var borderWidth: CGFloat? {
        switch self {
            case .borderWidth(let borderWidth):
                return borderWidth
            default: return nil
        }
    }

    var borderColor: UIColor? {
        switch self {
            case .borderColor(let borderColor):
                return borderColor
            default: return nil
        }
    }

    var text: String? {
        switch self {
            case .text(let text):
                return text
            default: return nil
        }
    }

    var font: UIFont? {
        switch self {
            case .font(let font):
                return font
            default: return nil
        }
    }

    var textColor: UIColor? {
        switch self {
            case .textColor(let textColor):
                return textColor
            default: return nil
        }
    }

    var `case`: Case? {
        switch self {
            case .`case`(let `case`):
                return `case`
            default: return nil
        }
    }

    var textAlignment: NSTextAlignment? {
        switch self {
            case .textAlignment(let textAlignment):
                return textAlignment
            default: return nil
        }
    }

    var adjustsFontSizeToFitWidth: Bool? {
        switch self {
            case .adjustsFontSizeToFitWidth(let adjustsFontSizeToFitWidth):
                return adjustsFontSizeToFitWidth
            default: return nil
        }
    }

    var placeholder: String? {
        switch self {
            case .placeholder(let placeholder):
                return placeholder
            default: return nil
        }
    }

    var editable: Bool? {
        switch self {
            case .editable(let editable):
                return editable
            default: return nil
        }
    }

    var clearsOnInsertion: Bool? {
        switch self {
            case .clearsOnInsertion(let clearsOnInsertion):
                return clearsOnInsertion
            default: return nil
        }
    }

    var clearsOnBeginEditing: Bool? {
        switch self {
            case .clearsOnBeginEditing(let clearsOnBeginEditing):
                return clearsOnBeginEditing
            default: return nil
        }
    }

    var inputView: UIView? {
        switch self {
            case .inputView(let inputView):
                return inputView
            default: return nil
        }
    }

    var inputAccessoryView: UIView? {
        switch self {
            case .inputAccessoryView(let inputAccessoryView):
                return inputAccessoryView
            default: return nil
        }
    }

    var allowsEditingTextAttributes: Bool? {
        switch self {
            case .allowsEditingTextAttributes(let allowsEditingTextAttributes):
                return allowsEditingTextAttributes
            default: return nil
        }
    }

    var dataDetectorTypes: UIDataDetectorTypes? {
        switch self {
            case .dataDetectorTypes(let dataDetectorTypes):
                return dataDetectorTypes
            default: return nil
        }
    }

    var typingAttributes: [NSAttributedString.Key: Any]? {
        switch self {
            case .typingAttributes(let typingAttributes):
                return typingAttributes
            default: return nil
        }
    }

    var numberOfLines: Int? {
        switch self {
            case .numberOfLines(let numberOfLines):
                return numberOfLines
            default: return nil
        }
    }

    var highlightedTextColor: UIColor? {
        switch self {
            case .highlightedTextColor(let highlightedTextColor):
                return highlightedTextColor
            default: return nil
        }
    }

    var minimumScaleFactor: CGFloat? {
        switch self {
            case .minimumScaleFactor(let minimumScaleFactor):
                return minimumScaleFactor
            default: return nil
        }
    }

    var baselineAdjustment: UIBaselineAdjustment? {
        switch self {
            case .baselineAdjustment(let baselineAdjustment):
                return baselineAdjustment
            default: return nil
        }
    }

    var shadowColor: UIColor? {
        switch self {
            case .shadowColor(let shadowColor):
                return shadowColor
            default: return nil
        }
    }

    var shadowOffset: CGSize? {
        switch self {
            case .shadowOffset(let shadowOffset):
                return shadowOffset
            default: return nil
        }
    }

    var attributedText: NSAttributedString? {
        switch self {
            case .attributedText(let attributedText):
                return attributedText
            default: return nil
        }
    }

    var autocapitalizationType: UITextAutocapitalizationType? {
        switch self {
            case .autocapitalizationType(let autocapitalizationType):
                return autocapitalizationType
            default: return nil
        }
    }

    var autocorrectionType: UITextAutocorrectionType? {
        switch self {
            case .autocorrectionType(let autocorrectionType):
                return autocorrectionType
            default: return nil
        }
    }

    var spellCheckingType: UITextSpellCheckingType? {
        switch self {
            case .spellCheckingType(let spellCheckingType):
                return spellCheckingType
            default: return nil
        }
    }

    var keyboardType: UIKeyboardType? {
        switch self {
            case .keyboardType(let keyboardType):
                return keyboardType
            default: return nil
        }
    }

    var keyboardAppearance: UIKeyboardAppearance? {
        switch self {
            case .keyboardAppearance(let keyboardAppearance):
                return keyboardAppearance
            default: return nil
        }
    }

    var returnKeyType: UIReturnKeyType? {
        switch self {
            case .returnKeyType(let returnKeyType):
                return returnKeyType
            default: return nil
        }
    }

    var enablesReturnKeyAutomatically: Bool? {
        switch self {
            case .enablesReturnKeyAutomatically(let enablesReturnKeyAutomatically):
                return enablesReturnKeyAutomatically
            default: return nil
        }
    }

    var isSecureTextEntry: Bool? {
        switch self {
            case .isSecureTextEntry(let isSecureTextEntry):
                return isSecureTextEntry
            default: return nil
        }
    }

    var textContentType: UITextContentType? {
        switch self {
            case .textContentType(let textContentType):
                return textContentType
            default: return nil
        }
    }

    var borderStyle: UITextField.BorderStyle? {
        switch self {
            case .borderStyle(let borderStyle):
                return borderStyle
            default: return nil
        }
    }

    var background: UIImage? {
        switch self {
            case .background(let background):
                return background
            default: return nil
        }
    }

    var disabledBackground: UIImage? {
        switch self {
            case .disabledBackground(let disabledBackground):
                return disabledBackground
            default: return nil
        }
    }

    var clearButtonMode: UITextField.ViewMode? {
        switch self {
            case .clearButtonMode(let clearButtonMode):
                return clearButtonMode
            default: return nil
        }
    }

    var leftView: UIView? {
        switch self {
            case .leftView(let leftView):
                return leftView
            default: return nil
        }
    }

    var leftViewMode: UITextField.ViewMode? {
        switch self {
            case .leftViewMode(let leftViewMode):
                return leftViewMode
            default: return nil
        }
    }

    var rightView: UIView? {
        switch self {
            case .rightView(let rightView):
                return rightView
            default: return nil
        }
    }

    var rightViewMode: UITextField.ViewMode? {
        switch self {
            case .rightViewMode(let rightViewMode):
                return rightViewMode
            default: return nil
        }
    }

    var selectedRange: NSRange? {
        switch self {
            case .selectedRange(let selectedRange):
                return selectedRange
            default: return nil
        }
    }

    var linkTextAttributes: [NSAttributedString.Key: Any]? {
        switch self {
            case .linkTextAttributes(let linkTextAttributes):
                return linkTextAttributes
            default: return nil
        }
    }

    var textContainerInset: UIEdgeInsets? {
        switch self {
            case .textContainerInset(let textContainerInset):
                return textContainerInset
            default: return nil
        }
    }

    var image: UIImage? {
        switch self {
            case .image(let image):
                return image
            default: return nil
        }
    }

    var highlightedImage: UIImage? {
        switch self {
            case .highlightedImage(let highlightedImage):
                return highlightedImage
            default: return nil
        }
    }

    var renderingMode: UIImage.RenderingMode? {
        switch self {
            case .renderingMode(let renderingMode):
                return renderingMode
            default: return nil
        }
    }

    var animationImages: [UIImage]? {
        switch self {
            case .animationImages(let animationImages):
                return animationImages
            default: return nil
        }
    }

    var highlightedAnimationImages: [UIImage]? {
        switch self {
            case .highlightedAnimationImages(let highlightedAnimationImages):
                return highlightedAnimationImages
            default: return nil
        }
    }

    var animationRepeatCount: Int? {
        switch self {
            case .animationRepeatCount(let animationRepeatCount):
                return animationRepeatCount
            default: return nil
        }
    }

    var animationDuration: TimeInterval? {
        switch self {
            case .animationDuration(let animationDuration):
                return animationDuration
            default: return nil
        }
    }

    var scrollEnabled: Bool? {
        switch self {
            case .scrollEnabled(let scrollEnabled):
                return scrollEnabled
            default: return nil
        }
    }

    var contentSize: CGSize? {
        switch self {
            case .contentSize(let contentSize):
                return contentSize
            default: return nil
        }
    }

    var contentInset: UIEdgeInsets? {
        switch self {
            case .contentInset(let contentInset):
                return contentInset
            default: return nil
        }
    }

    var bounces: Bool? {
        switch self {
            case .bounces(let bounces):
                return bounces
            default: return nil
        }
    }

    var alwaysBounceVertical: Bool? {
        switch self {
            case .alwaysBounceVertical(let alwaysBounceVertical):
                return alwaysBounceVertical
            default: return nil
        }
    }

    var alwaysBounceHorizontal: Bool? {
        switch self {
            case .alwaysBounceHorizontal(let alwaysBounceHorizontal):
                return alwaysBounceHorizontal
            default: return nil
        }
    }

    var pagingEnabled: Bool? {
        switch self {
            case .pagingEnabled(let pagingEnabled):
                return pagingEnabled
            default: return nil
        }
    }

    var showsHorizontalScrollIndicator: Bool? {
        switch self {
            case .showsHorizontalScrollIndicator(let showsHorizontalScrollIndicator):
                return showsHorizontalScrollIndicator
            default: return nil
        }
    }

    var showsVerticalScrollIndicator: Bool? {
        switch self {
            case .showsVerticalScrollIndicator(let showsVerticalScrollIndicator):
                return showsVerticalScrollIndicator
            default: return nil
        }
    }

    var scrollIndicatorInsets: UIEdgeInsets? {
        switch self {
            case .scrollIndicatorInsets(let scrollIndicatorInsets):
                return scrollIndicatorInsets
            default: return nil
        }
    }

    var indicatorStyle: UIScrollView.IndicatorStyle? {
        switch self {
            case .indicatorStyle(let indicatorStyle):
                return indicatorStyle
            default: return nil
        }
    }

    var decelerationRate: UIScrollView.DecelerationRate? {
        switch self {
            case .decelerationRate(let decelerationRate):
                return decelerationRate
            default: return nil
        }
    }

    var delaysContentTouches: Bool? {
        switch self {
            case .delaysContentTouches(let delaysContentTouches):
                return delaysContentTouches
            default: return nil
        }
    }

    var canCancelContentTouches: Bool? {
        switch self {
            case .canCancelContentTouches(let canCancelContentTouches):
                return canCancelContentTouches
            default: return nil
        }
    }

    var minimumZoomScale: CGFloat? {
        switch self {
            case .minimumZoomScale(let minimumZoomScale):
                return minimumZoomScale
            default: return nil
        }
    }

    var maximumZoomScale: CGFloat? {
        switch self {
            case .maximumZoomScale(let maximumZoomScale):
                return maximumZoomScale
            default: return nil
        }
    }

    var zoomScale: CGFloat? {
        switch self {
            case .zoomScale(let zoomScale):
                return zoomScale
            default: return nil
        }
    }

    var bouncesZoom: Bool? {
        switch self {
            case .bouncesZoom(let bouncesZoom):
                return bouncesZoom
            default: return nil
        }
    }

    var scrollsToTop: Bool? {
        switch self {
            case .scrollsToTop(let scrollsToTop):
                return scrollsToTop
            default: return nil
        }
    }

    var keyboardDismissMode: UIScrollView.KeyboardDismissMode? {
        switch self {
            case .keyboardDismissMode(let keyboardDismissMode):
                return keyboardDismissMode
            default: return nil
        }
    }

    var states: [ControlStateStyle]? {
        switch self {
            case .states(let states):
                return states
            default: return nil
        }
    }

    var contentVerticalAlignment: UIControl.ContentVerticalAlignment? {
        switch self {
            case .contentVerticalAlignment(let contentVerticalAlignment):
                return contentVerticalAlignment
            default: return nil
        }
    }

    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment? {
        switch self {
            case .contentHorizontalAlignment(let contentHorizontalAlignment):
                return contentHorizontalAlignment
            default: return nil
        }
    }

    var targets: [Actor]? {
        switch self {
            case .targets(let targets):
                return targets
            default: return nil
        }
    }

    var enabled: Bool? {
        switch self {
            case .enabled(let enabled):
                return enabled
            default: return nil
        }
    }

    var selected: Bool? {
        switch self {
            case .selected(let selected):
                return selected
            default: return nil
        }
    }

    var highlighted: Bool? {
        switch self {
            case .highlighted(let highlighted):
                return highlighted
            default: return nil
        }
    }

    var contentEdgeInsets: UIEdgeInsets? {
        switch self {
            case .contentEdgeInsets(let contentEdgeInsets):
                return contentEdgeInsets
            default: return nil
        }
    }

    var titleEdgeInsets: UIEdgeInsets? {
        switch self {
            case .titleEdgeInsets(let titleEdgeInsets):
                return titleEdgeInsets
            default: return nil
        }
    }

    var reversesTitleShadowWhenHighlighted: Bool? {
        switch self {
            case .reversesTitleShadowWhenHighlighted(let reversesTitleShadowWhenHighlighted):
                return reversesTitleShadowWhenHighlighted
            default: return nil
        }
    }

    var imageEdgeInsets: UIEdgeInsets? {
        switch self {
            case .imageEdgeInsets(let imageEdgeInsets):
                return imageEdgeInsets
            default: return nil
        }
    }

    var adjustsImageWhenHighlighted: Bool? {
        switch self {
            case .adjustsImageWhenHighlighted(let adjustsImageWhenHighlighted):
                return adjustsImageWhenHighlighted
            default: return nil
        }
    }

    var adjustsImageWhenDisabled: Bool? {
        switch self {
            case .adjustsImageWhenDisabled(let adjustsImageWhenDisabled):
                return adjustsImageWhenDisabled
            default: return nil
        }
    }

    var showsTouchWhenHighlighted: Bool? {
        switch self {
            case .showsTouchWhenHighlighted(let showsTouchWhenHighlighted):
                return showsTouchWhenHighlighted
            default: return nil
        }
    }

    var axis: NSLayoutConstraint.Axis? {
        switch self {
            case .axis(let axis):
                return axis
            default: return nil
        }
    }

    var distribution: UIStackView.Distribution? {
        switch self {
            case .distribution(let distribution):
                return distribution
            default: return nil
        }
    }

    var alignment: UIStackView.Alignment? {
        switch self {
            case .alignment(let alignment):
                return alignment
            default: return nil
        }
    }

    var spacing: CGFloat? {
        switch self {
            case .spacing(let spacing):
                return spacing
            default: return nil
        }
    }

    var margin: MarginExpressible? {
        switch self {
            case .margin(let margin):
                return margin
            default: return nil
        }
    }

    var marginsRelative: Bool? {
        switch self {
            case .marginsRelative(let marginsRelative):
                return marginsRelative
            default: return nil
        }
    }

    var baselineRelative: Bool? {
        switch self {
            case .baselineRelative(let baselineRelative):
                return baselineRelative
            default: return nil
        }
    }

    var views: [UIView?]? {
        switch self {
            case .views(let views):
                return views
            default: return nil
        }
    }

    var registerCells: [RegisterableCell]? {
        switch self {
            case .registerCells(let registerCells):
                return registerCells
            default: return nil
        }
    }

    var backgroundView: UIView? {
        switch self {
            case .backgroundView(let backgroundView):
                return backgroundView
            default: return nil
        }
    }

    var allowsMultipleSelection: Bool? {
        switch self {
            case .allowsMultipleSelection(let allowsMultipleSelection):
                return allowsMultipleSelection
            default: return nil
        }
    }

    var allowsSelection: Bool? {
        switch self {
            case .allowsSelection(let allowsSelection):
                return allowsSelection
            default: return nil
        }
    }

    var remembersLastFocusedIndexPath: Bool? {
        switch self {
            case .remembersLastFocusedIndexPath(let remembersLastFocusedIndexPath):
                return remembersLastFocusedIndexPath
            default: return nil
        }
    }

    var prefetchDataSource: NSObjectProtocol? {
        switch self {
            case .prefetchDataSource(let prefetchDataSource):
                return prefetchDataSource
            default: return nil
        }
    }

    var sectionIndexMinimumDisplayRowCount: Int? {
        switch self {
            case .sectionIndexMinimumDisplayRowCount(let sectionIndexMinimumDisplayRowCount):
                return sectionIndexMinimumDisplayRowCount
            default: return nil
        }
    }

    var sectionIndexTrackingBackgroundColor: UIColor? {
        switch self {
            case .sectionIndexTrackingBackgroundColor(let sectionIndexTrackingBackgroundColor):
                return sectionIndexTrackingBackgroundColor
            default: return nil
        }
    }

    var sectionIndexBackgroundColor: UIColor? {
        switch self {
            case .sectionIndexBackgroundColor(let sectionIndexBackgroundColor):
                return sectionIndexBackgroundColor
            default: return nil
        }
    }

    var sectionIndexColor: UIColor? {
        switch self {
            case .sectionIndexColor(let sectionIndexColor):
                return sectionIndexColor
            default: return nil
        }
    }

    var rowHeight: CGFloat? {
        switch self {
            case .rowHeight(let rowHeight):
                return rowHeight
            default: return nil
        }
    }

    var separatorStyle: UITableViewCell.SeparatorStyle? {
        switch self {
            case .separatorStyle(let separatorStyle):
                return separatorStyle
            default: return nil
        }
    }

    var separatorColor: UIColor? {
        switch self {
            case .separatorColor(let separatorColor):
                return separatorColor
            default: return nil
        }
    }

    var separatorEffect: UIVisualEffect? {
        switch self {
            case .separatorEffect(let separatorEffect):
                return separatorEffect
            default: return nil
        }
    }

    var separatorInset: UIEdgeInsets? {
        switch self {
            case .separatorInset(let separatorInset):
                return separatorInset
            default: return nil
        }
    }

    var cellLayoutMarginsFollowReadableWidth: Bool? {
        switch self {
            case .cellLayoutMarginsFollowReadableWidth(let cellLayoutMarginsFollowReadableWidth):
                return cellLayoutMarginsFollowReadableWidth
            default: return nil
        }
    }

    var sectionHeaderHeight: CGFloat? {
        switch self {
            case .sectionHeaderHeight(let sectionHeaderHeight):
                return sectionHeaderHeight
            default: return nil
        }
    }

    var sectionFooterHeight: CGFloat? {
        switch self {
            case .sectionFooterHeight(let sectionFooterHeight):
                return sectionFooterHeight
            default: return nil
        }
    }

    var estimatedRowHeight: CGFloat? {
        switch self {
            case .estimatedRowHeight(let estimatedRowHeight):
                return estimatedRowHeight
            default: return nil
        }
    }

    var estimatedSectionHeaderHeight: CGFloat? {
        switch self {
            case .estimatedSectionHeaderHeight(let estimatedSectionHeaderHeight):
                return estimatedSectionHeaderHeight
            default: return nil
        }
    }

    var estimatedSectionFooterHeight: CGFloat? {
        switch self {
            case .estimatedSectionFooterHeight(let estimatedSectionFooterHeight):
                return estimatedSectionFooterHeight
            default: return nil
        }
    }

    var allowsSelectionDuringEditing: Bool? {
        switch self {
            case .allowsSelectionDuringEditing(let allowsSelectionDuringEditing):
                return allowsSelectionDuringEditing
            default: return nil
        }
    }

    var allowsMultipleSelectionDuringEditing: Bool? {
        switch self {
            case .allowsMultipleSelectionDuringEditing(let allowsMultipleSelectionDuringEditing):
                return allowsMultipleSelectionDuringEditing
            default: return nil
        }
    }

    var isEditing: Bool? {
        switch self {
            case .isEditing(let isEditing):
                return isEditing
            default: return nil
        }
    }

    var collectionViewLayout: UICollectionViewLayout? {
        switch self {
            case .collectionViewLayout(let collectionViewLayout):
                return collectionViewLayout
            default: return nil
        }
    }

    var itemSize: CGSize? {
        switch self {
            case .itemSize(let itemSize):
                return itemSize
            default: return nil
        }
    }

    var isPrefetchingEnabled: Bool? {
        switch self {
            case .isPrefetchingEnabled(let isPrefetchingEnabled):
                return isPrefetchingEnabled
            default: return nil
        }
    }

    var prompt: String? {
        switch self {
            case .prompt(let prompt):
                return prompt
            default: return nil
        }
    }

    var searchBarStyle: UISearchBar.Style? {
        switch self {
            case .searchBarStyle(let searchBarStyle):
                return searchBarStyle
            default: return nil
        }
    }

    var segments: [SegmentContent]? {
        switch self {
            case .segments(let segments):
                return segments
            default: return nil
        }
    }

    var thumbTintColor: UIColor? {
        switch self {
            case .thumbTintColor(let thumbTintColor):
                return thumbTintColor
            default: return nil
        }
    }

    var on: Bool? {
        switch self {
            case .on(let on):
                return on
            default: return nil
        }
    }

    var onTintColor: UIColor? {
        switch self {
            case .onTintColor(let onTintColor):
                return onTintColor
            default: return nil
        }
    }

    var onImage: UIImage? {
        switch self {
            case .onImage(let onImage):
                return onImage
            default: return nil
        }
    }

    var offImge: UIImage? {
        switch self {
            case .offImge(let offImge):
                return offImge
            default: return nil
        }
    }

    var webPage: URLRequest? {
        switch self {
            case .webPage(let webPage):
                return webPage
            default: return nil
        }
    }

    var sliderValue: Double? {
        switch self {
            case .sliderValue(let sliderValue):
                return sliderValue
            default: return nil
        }
    }

    var sliderRange: Range<Double>? {
        switch self {
            case .sliderRange(let sliderRange):
                return sliderRange
            default: return nil
        }
    }

    var spin: Bool? {
        switch self {
            case .spin(let spin):
                return spin
            default: return nil
        }
    }

    var hidesWhenStopped: Bool? {
        switch self {
            case .hidesWhenStopped(let hidesWhenStopped):
                return hidesWhenStopped
            default: return nil
        }
    }

    var spinnerStyle: UIActivityIndicatorView.Style? {
        switch self {
            case .spinnerStyle(let spinnerStyle):
                return spinnerStyle
            default: return nil
        }
    }

    var spinnerScale: CGFloat? {
        switch self {
            case .spinnerScale(let spinnerScale):
                return spinnerScale
            default: return nil
        }
    }

    var progressViewStyle: UIProgressView.Style? {
        switch self {
            case .progressViewStyle(let progressViewStyle):
                return progressViewStyle
            default: return nil
        }
    }

    var progress: Float? {
        switch self {
            case .progress(let progress):
                return progress
            default: return nil
        }
    }

    var progressTintColor: UIColor? {
        switch self {
            case .progressTintColor(let progressTintColor):
                return progressTintColor
            default: return nil
        }
    }

    var progressImage: UIImage? {
        switch self {
            case .progressImage(let progressImage):
                return progressImage
            default: return nil
        }
    }

    var trackTintColor: UIColor? {
        switch self {
            case .trackTintColor(let trackTintColor):
                return trackTintColor
            default: return nil
        }
    }

    var trackImage: UIImage? {
        switch self {
            case .trackImage(let trackImage):
                return trackImage
            default: return nil
        }
    }

    var currentPage: Int? {
        switch self {
            case .currentPage(let currentPage):
                return currentPage
            default: return nil
        }
    }

    var numberOfPages: Int? {
        switch self {
            case .numberOfPages(let numberOfPages):
                return numberOfPages
            default: return nil
        }
    }

    var hidesForSinglePage: Bool? {
        switch self {
            case .hidesForSinglePage(let hidesForSinglePage):
                return hidesForSinglePage
            default: return nil
        }
    }

    var pageIndicatorTintColor: UIColor? {
        switch self {
            case .pageIndicatorTintColor(let pageIndicatorTintColor):
                return pageIndicatorTintColor
            default: return nil
        }
    }

    var currentPageIndicatorTintColor: UIColor? {
        switch self {
            case .currentPageIndicatorTintColor(let currentPageIndicatorTintColor):
                return currentPageIndicatorTintColor
            default: return nil
        }
    }

}

public enum ViewAttributeStripped: String, StrippedRepresentation {
    case runtimePlaceholderColor, runtimePlaceholderFont, runtimeTextFieldInset, runtimeTextFieldEdgeInset, custom, delegate, dataSource, dataSourceDelegate, hidden, color, verticalHugging, verticalCompression, horizontalHugging, horizontalCompression, contentMode, height, width, layoutMargins, userInteractable, tintColor, clipsToBounds, alpha, opaque, exclusiveTouch, multipleTouchEnabled, clearsContextBeforeDrawing, semanticContentAttribute, cornerRadius, roundedBy, borderWidth, borderColor, text, font, textColor, `case`, textAlignment, adjustsFontSizeToFitWidth, placeholder, editable, clearsOnInsertion, clearsOnBeginEditing, inputView, inputAccessoryView, allowsEditingTextAttributes, dataDetectorTypes, typingAttributes, numberOfLines, highlightedTextColor, minimumScaleFactor, baselineAdjustment, shadowColor, shadowOffset, attributedText, autocapitalizationType, autocorrectionType, spellCheckingType, keyboardType, keyboardAppearance, returnKeyType, enablesReturnKeyAutomatically, isSecureTextEntry, textContentType, borderStyle, background, disabledBackground, clearButtonMode, leftView, leftViewMode, rightView, rightViewMode, selectedRange, linkTextAttributes, textContainerInset, image, highlightedImage, renderingMode, animationImages, highlightedAnimationImages, animationRepeatCount, animationDuration, scrollEnabled, contentSize, contentInset, bounces, alwaysBounceVertical, alwaysBounceHorizontal, pagingEnabled, showsHorizontalScrollIndicator, showsVerticalScrollIndicator, scrollIndicatorInsets, indicatorStyle, decelerationRate, delaysContentTouches, canCancelContentTouches, minimumZoomScale, maximumZoomScale, zoomScale, bouncesZoom, scrollsToTop, keyboardDismissMode, states, contentVerticalAlignment, contentHorizontalAlignment, targets, enabled, selected, highlighted, contentEdgeInsets, titleEdgeInsets, reversesTitleShadowWhenHighlighted, imageEdgeInsets, adjustsImageWhenHighlighted, adjustsImageWhenDisabled, showsTouchWhenHighlighted, axis, distribution, alignment, spacing, margin, marginsRelative, baselineRelative, views, registerCells, backgroundView, allowsMultipleSelection, allowsSelection, remembersLastFocusedIndexPath, prefetchDataSource, sectionIndexMinimumDisplayRowCount, sectionIndexTrackingBackgroundColor, sectionIndexBackgroundColor, sectionIndexColor, rowHeight, separatorStyle, separatorColor, separatorEffect, separatorInset, cellLayoutMarginsFollowReadableWidth, sectionHeaderHeight, sectionFooterHeight, estimatedRowHeight, estimatedSectionHeaderHeight, estimatedSectionFooterHeight, allowsSelectionDuringEditing, allowsMultipleSelectionDuringEditing, isEditing, collectionViewLayout, itemSize, isPrefetchingEnabled, prompt, searchBarStyle, segments, thumbTintColor, on, onTintColor, onImage, offImge, webPage, sliderValue, sliderRange, spin, hidesWhenStopped, spinnerStyle, spinnerScale, progressViewStyle, progress, progressTintColor, progressImage, trackTintColor, trackImage, currentPage, numberOfPages, hidesForSinglePage, pageIndicatorTintColor, currentPageIndicatorTintColor
} 

extension ViewAttribute: AssociatedValueStrippable {
    public typealias Stripped = ViewAttributeStripped
    public var stripped: Stripped {
        switch self {
            case .runtimePlaceholderColor: return .runtimePlaceholderColor
            case .runtimePlaceholderFont: return .runtimePlaceholderFont
            case .runtimeTextFieldInset: return .runtimeTextFieldInset
            case .runtimeTextFieldEdgeInset: return .runtimeTextFieldEdgeInset
            case .custom: return .custom
            case .delegate: return .delegate
            case .dataSource: return .dataSource
            case .dataSourceDelegate: return .dataSourceDelegate
            case .hidden: return .hidden
            case .color: return .color
            case .verticalHugging: return .verticalHugging
            case .verticalCompression: return .verticalCompression
            case .horizontalHugging: return .horizontalHugging
            case .horizontalCompression: return .horizontalCompression
            case .contentMode: return .contentMode
            case .height: return .height
            case .width: return .width
            case .layoutMargins: return .layoutMargins
            case .userInteractable: return .userInteractable
            case .tintColor: return .tintColor
            case .clipsToBounds: return .clipsToBounds
            case .alpha: return .alpha
            case .opaque: return .opaque
            case .exclusiveTouch: return .exclusiveTouch
            case .multipleTouchEnabled: return .multipleTouchEnabled
            case .clearsContextBeforeDrawing: return .clearsContextBeforeDrawing
            case .semanticContentAttribute: return .semanticContentAttribute
            case .cornerRadius: return .cornerRadius
            case .roundedBy: return .roundedBy
            case .borderWidth: return .borderWidth
            case .borderColor: return .borderColor
            case .text: return .text
            case .font: return .font
            case .textColor: return .textColor
            case .`case`: return .`case`
            case .textAlignment: return .textAlignment
            case .adjustsFontSizeToFitWidth: return .adjustsFontSizeToFitWidth
            case .placeholder: return .placeholder
            case .editable: return .editable
            case .clearsOnInsertion: return .clearsOnInsertion
            case .clearsOnBeginEditing: return .clearsOnBeginEditing
            case .inputView: return .inputView
            case .inputAccessoryView: return .inputAccessoryView
            case .allowsEditingTextAttributes: return .allowsEditingTextAttributes
            case .dataDetectorTypes: return .dataDetectorTypes
            case .typingAttributes: return .typingAttributes
            case .numberOfLines: return .numberOfLines
            case .highlightedTextColor: return .highlightedTextColor
            case .minimumScaleFactor: return .minimumScaleFactor
            case .baselineAdjustment: return .baselineAdjustment
            case .shadowColor: return .shadowColor
            case .shadowOffset: return .shadowOffset
            case .attributedText: return .attributedText
            case .autocapitalizationType: return .autocapitalizationType
            case .autocorrectionType: return .autocorrectionType
            case .spellCheckingType: return .spellCheckingType
            case .keyboardType: return .keyboardType
            case .keyboardAppearance: return .keyboardAppearance
            case .returnKeyType: return .returnKeyType
            case .enablesReturnKeyAutomatically: return .enablesReturnKeyAutomatically
            case .isSecureTextEntry: return .isSecureTextEntry
            case .textContentType: return .textContentType
            case .borderStyle: return .borderStyle
            case .background: return .background
            case .disabledBackground: return .disabledBackground
            case .clearButtonMode: return .clearButtonMode
            case .leftView: return .leftView
            case .leftViewMode: return .leftViewMode
            case .rightView: return .rightView
            case .rightViewMode: return .rightViewMode
            case .selectedRange: return .selectedRange
            case .linkTextAttributes: return .linkTextAttributes
            case .textContainerInset: return .textContainerInset
            case .image: return .image
            case .highlightedImage: return .highlightedImage
            case .renderingMode: return .renderingMode
            case .animationImages: return .animationImages
            case .highlightedAnimationImages: return .highlightedAnimationImages
            case .animationRepeatCount: return .animationRepeatCount
            case .animationDuration: return .animationDuration
            case .scrollEnabled: return .scrollEnabled
            case .contentSize: return .contentSize
            case .contentInset: return .contentInset
            case .bounces: return .bounces
            case .alwaysBounceVertical: return .alwaysBounceVertical
            case .alwaysBounceHorizontal: return .alwaysBounceHorizontal
            case .pagingEnabled: return .pagingEnabled
            case .showsHorizontalScrollIndicator: return .showsHorizontalScrollIndicator
            case .showsVerticalScrollIndicator: return .showsVerticalScrollIndicator
            case .scrollIndicatorInsets: return .scrollIndicatorInsets
            case .indicatorStyle: return .indicatorStyle
            case .decelerationRate: return .decelerationRate
            case .delaysContentTouches: return .delaysContentTouches
            case .canCancelContentTouches: return .canCancelContentTouches
            case .minimumZoomScale: return .minimumZoomScale
            case .maximumZoomScale: return .maximumZoomScale
            case .zoomScale: return .zoomScale
            case .bouncesZoom: return .bouncesZoom
            case .scrollsToTop: return .scrollsToTop
            case .keyboardDismissMode: return .keyboardDismissMode
            case .states: return .states
            case .contentVerticalAlignment: return .contentVerticalAlignment
            case .contentHorizontalAlignment: return .contentHorizontalAlignment
            case .targets: return .targets
            case .enabled: return .enabled
            case .selected: return .selected
            case .highlighted: return .highlighted
            case .contentEdgeInsets: return .contentEdgeInsets
            case .titleEdgeInsets: return .titleEdgeInsets
            case .reversesTitleShadowWhenHighlighted: return .reversesTitleShadowWhenHighlighted
            case .imageEdgeInsets: return .imageEdgeInsets
            case .adjustsImageWhenHighlighted: return .adjustsImageWhenHighlighted
            case .adjustsImageWhenDisabled: return .adjustsImageWhenDisabled
            case .showsTouchWhenHighlighted: return .showsTouchWhenHighlighted
            case .axis: return .axis
            case .distribution: return .distribution
            case .alignment: return .alignment
            case .spacing: return .spacing
            case .margin: return .margin
            case .marginsRelative: return .marginsRelative
            case .baselineRelative: return .baselineRelative
            case .views: return .views
            case .registerCells: return .registerCells
            case .backgroundView: return .backgroundView
            case .allowsMultipleSelection: return .allowsMultipleSelection
            case .allowsSelection: return .allowsSelection
            case .remembersLastFocusedIndexPath: return .remembersLastFocusedIndexPath
            case .prefetchDataSource: return .prefetchDataSource
            case .sectionIndexMinimumDisplayRowCount: return .sectionIndexMinimumDisplayRowCount
            case .sectionIndexTrackingBackgroundColor: return .sectionIndexTrackingBackgroundColor
            case .sectionIndexBackgroundColor: return .sectionIndexBackgroundColor
            case .sectionIndexColor: return .sectionIndexColor
            case .rowHeight: return .rowHeight
            case .separatorStyle: return .separatorStyle
            case .separatorColor: return .separatorColor
            case .separatorEffect: return .separatorEffect
            case .separatorInset: return .separatorInset
            case .cellLayoutMarginsFollowReadableWidth: return .cellLayoutMarginsFollowReadableWidth
            case .sectionHeaderHeight: return .sectionHeaderHeight
            case .sectionFooterHeight: return .sectionFooterHeight
            case .estimatedRowHeight: return .estimatedRowHeight
            case .estimatedSectionHeaderHeight: return .estimatedSectionHeaderHeight
            case .estimatedSectionFooterHeight: return .estimatedSectionFooterHeight
            case .allowsSelectionDuringEditing: return .allowsSelectionDuringEditing
            case .allowsMultipleSelectionDuringEditing: return .allowsMultipleSelectionDuringEditing
            case .isEditing: return .isEditing
            case .collectionViewLayout: return .collectionViewLayout
            case .itemSize: return .itemSize
            case .isPrefetchingEnabled: return .isPrefetchingEnabled
            case .prompt: return .prompt
            case .searchBarStyle: return .searchBarStyle
            case .segments: return .segments
            case .thumbTintColor: return .thumbTintColor
            case .on: return .on
            case .onTintColor: return .onTintColor
            case .onImage: return .onImage
            case .offImge: return .offImge
            case .webPage: return .webPage
            case .sliderValue: return .sliderValue
            case .sliderRange: return .sliderRange
            case .spin: return .spin
            case .hidesWhenStopped: return .hidesWhenStopped
            case .spinnerStyle: return .spinnerStyle
            case .spinnerScale: return .spinnerScale
            case .progressViewStyle: return .progressViewStyle
            case .progress: return .progress
            case .progressTintColor: return .progressTintColor
            case .progressImage: return .progressImage
            case .trackTintColor: return .trackTintColor
            case .trackImage: return .trackImage
            case .currentPage: return .currentPage
            case .numberOfPages: return .numberOfPages
            case .hidesForSinglePage: return .hidesForSinglePage
            case .pageIndicatorTintColor: return .pageIndicatorTintColor
            case .currentPageIndicatorTintColor: return .currentPageIndicatorTintColor
        }
    }
}

extension ViewAttributeStripped {
    public var hashValue: Int {
        return rawValue.hashValue
    }

}

extension ViewAttribute: Hashable {
    public var hashValue: Int {
        return stripped.hashValue
    }
}

