//
//  MergeOperatorReturningComposable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-04.
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
public func <<- <C: Composable>(lhs: C.StyleType, rhs: C.StyleType) -> C {
    return C(lhs <<- rhs)
}
// RHS SLAVE
public func <- <C: Composable>(lhs: C.StyleType, rhs: C.StyleType) -> C {
    return C(lhs <- rhs)
}

//MARK: RHS `[Attributed.Attribute]`
// RHS MASTER
public func <<- <C: Composable>(lhs: C.StyleType, rhs: [C.StyleType.Attribute]) -> C {
    return C(lhs <<- rhs)
}

// RHS SLAVE
public func <- <C: Composable>(lhs: C.StyleType, rhs: [C.StyleType.Attribute]) -> C {
    return C(lhs <- rhs)
}

//MARK: RHS `Attributed.Attribute`
// RHS MASTER
public func <<- <C: Composable>(lhs: C.StyleType, rhs: C.StyleType.Attribute) -> C {
    return C(lhs <<- rhs)
}

// RHS SLAVE
public func <- <C: Composable>(lhs: C.StyleType, rhs: C.StyleType.Attribute) -> C {
    return C(lhs <- rhs)
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
public func <<- <C: Composable>(lhs: [C.StyleType.Attribute], rhs: C.StyleType) -> C {
    return C(lhs <<- rhs)
}

// RHS SLAVE
public func <- <C: Composable>(lhs: [C.StyleType.Attribute], rhs: C.StyleType) -> C {
    return C(lhs <- rhs)
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
public func <<- <C: Composable>(lhs: C.StyleType.Attribute, rhs: C.StyleType) -> C {
    return C([lhs] <<- rhs)
}

// RHS SLAVE
public func <- <C: Composable>(lhs: C.StyleType.Attribute, rhs: C.StyleType) -> C {
    return C([lhs] <- rhs)
}

