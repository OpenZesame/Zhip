//
//  EmptyInitializable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

/// Protocol for creating instances without having to pass any arguments.
///
/// Actually we just want a protocol with this empty initializer `init()`
///
/// So this would be our optimal protocol:
///
/// ```
/// protocol EmptyInitializable {
///    init()
/// }
///
/// ```
///
/// We want to be able to initialize any UIKit view (UILabel, UIButton, UICollectionView etc...) using an empty initializer.
/// Most UIKit classes already have an empty initializer, but some does not, e.g. `UICollectionView`.
///
/// However, as of today (Jun 2017, Swift 3.1, Xcode 8.3.2...), trying to make UIKit classes
/// e.g. `UICollectionView` conform to this protocol causes compile error:
///
/// ```
/// extension UICollectionView: EmptyInitializable {
///    // Compilation error: "Initializer 'init()' with Objective-C selector 'init' conflicts with implicit initializer 'init()' with the same Objective-C selector"
///    convenience init() { // must be marked `convenience` since it is an initializer in an extension
///        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
///    }
/// }
/// ```
///
/// We try to fix this by adding annotation `@nonobjc` to the `init`:
///
/// ```
/// extension UICollectionView: EmptyInitializable {
///    // Compilation error: "Initializer requirement 'init()' can only be statisfied by a `required` initializer in the definition of non-final class `UICollectionView`"
///    @nonobjc
///    convenience init() {
///        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
///    }
/// }
/// ```
///
/// Of course we cannot make `UICollectionView` final since it is not our class (duh)... however trying to mark the initializer `required` we get another error:
/// ```
/// extension UICollectionView: EmptyInitializable {
///    // Two compilation errors:
///    // "'required' initializer must be declared directly in class 'UICollectionView' (not in an extension)"
///    // "Initializer requirement 'init()' can only be satisfied by a `required` initializer in the definition of non-final class 'UICollectionView'"
///    @nonobjc
///    required convenience public init() {
///        self.init(frame: .zero)
///    }
/// }
/// ```
///
/// So since it is not as of today possible to do what we want, let us create a sort of "hacky" workaround.
/// Lets declare a static function "createEmpty() -> Styled", where `Styled` is an associatedtype actually
/// just refering to itself.
public protocol EmptyInitializable {
    associatedtype Styled
    static func createEmpty() -> Styled
}
