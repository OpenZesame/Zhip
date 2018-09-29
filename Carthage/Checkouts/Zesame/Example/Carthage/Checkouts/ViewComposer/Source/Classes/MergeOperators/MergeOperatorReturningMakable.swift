//
//  MergeOperatorReturningMakable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-05.
//
//

import Foundation

////////////////////////////////////////////////
//MARK: -
//MARK: -
//MARK: LHS: `Attributed`
//MARK: -
//MARK: -
////////////////////////////////////////////////

//MARK: RHS `Attributed`
// RHS MASTER
public func <<- <M: Makeable>(lhs: M.StyleType, rhs: M.StyleType) -> M where M.Styled == M {
    return M.make(lhs <<- rhs)
}

// RHS SLAVE
public func <- <M: Makeable>(lhs: M.StyleType, rhs: M.StyleType) -> M where M.Styled == M {
    return M.make(lhs <- rhs)
}

//MARK: RHS `[Attributed.Attribute]`
// RHS MASTER
public func <<- <M: Makeable>(lhs: M.StyleType, rhs: [M.StyleType.Attribute]) -> M where M.Styled == M {
    return M.make(lhs <<- rhs)
}

// RHS SLAVE
public func <- <M: Makeable>(lhs: M.StyleType, rhs: [M.StyleType.Attribute]) -> M where M.Styled == M {
    return M.make(lhs <- rhs)
}

//MARK: RHS `Attributed.Attribute`
// RHS MASTER
public func <<- <M: Makeable>(lhs: M.StyleType, rhs: M.StyleType.Attribute) -> M where M.Styled == M {
    return M.make(lhs <<- rhs)
}

// RHS SLAVE
public func <- <M: Makeable>(lhs: M.StyleType, rhs: M.StyleType.Attribute) -> M where M.Styled == M {
    return M.make(lhs <- rhs)
}

////////////////////////////////////////////////
//MARK: -
//MARK: -
//MARK: LHS: `[Attributed.Attribute]`
//MARK: -
//MARK: -
////////////////////////////////////////////////

//MARK: RHS `Attributed`
// RHS MASTER
public func <<- <M: Makeable>(lhs: [M.StyleType.Attribute], rhs: M.StyleType) -> M where M.Styled == M {
    return M.make(lhs <<- rhs)
}

// RHS SLAVE
public func <- <M: Makeable>(lhs: [M.StyleType.Attribute], rhs: M.StyleType) -> M where M.Styled == M {
    return M.make(lhs <- rhs)
}

////////////////////////////////////////////////
//MARK: -
//MARK: -
//MARK: LHS: `Attributed.Attribute`
//MARK: -
//MARK: -
////////////////////////////////////////////////

//MARK: RHS `Attributed`
// RHS MASTER
public func <<- <M: Makeable>(lhs: M.StyleType.Attribute, rhs: M.StyleType) -> M where M.Styled == M {
    return M.make([lhs] <<- rhs)
}

// RHS SLAVE
public func <- <M: Makeable>(lhs: M.StyleType.Attribute, rhs: M.StyleType) -> M where M.Styled == M {
    return M.make([lhs] <- rhs)
}

