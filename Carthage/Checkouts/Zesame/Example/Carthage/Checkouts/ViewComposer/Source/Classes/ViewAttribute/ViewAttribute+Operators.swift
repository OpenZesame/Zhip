//
//  ViewAttribute+Operators.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-04.
//
//

import Foundation

//MARK: RHS `[ViewAttribute]`
// RHS MASTER
public func <<- (lhs: [ViewAttribute], rhs: [ViewAttribute]) -> ViewStyle {
    return lhs.merge(master: rhs)
}

// RHS SLAVE
public func <- (lhs: [ViewAttribute], rhs: [ViewAttribute]) -> ViewStyle {
    return lhs.merge(slave: rhs)
}

//MARK: RHS `ViewAttribute`
// RHS MASTER
public func <<- (lhs: [ViewAttribute], rhs: ViewAttribute) -> ViewStyle {
    return lhs <<- [rhs]
}

// RHS SLAVE
public func <- (lhs: [ViewAttribute], rhs: ViewAttribute) -> ViewStyle {
    return lhs <- [rhs]
}

//MARK: RHS `[ViewAttribute]`
// RHS MASTER
public func <<- (lhs: ViewAttribute, rhs: [ViewAttribute]) -> ViewStyle {
    return [lhs] <<- rhs
}

// RHS SLAVE
public func <- (lhs: ViewAttribute, rhs: [ViewAttribute]) -> ViewStyle {
    return [lhs] <- rhs
}

//MARK: RHS `ViewAttribute`
// RHS MASTER
public func <<- (lhs: ViewAttribute, rhs: ViewAttribute) -> ViewStyle {
    return [lhs] <<- rhs
}

// RHS SLAVE
public func <- (lhs: ViewAttribute, rhs: ViewAttribute) -> ViewStyle {
    return [lhs] <- rhs
}
