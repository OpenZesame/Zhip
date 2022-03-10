//
//  StatefulViewFragment.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-03-05.
//

import SwiftUI

public protocol StatefulViewFragment: View {
    associatedtype ViewModel: ObservableObject
    
    /// Ugly hack **just** used to enforce the usage of `@StateObject`
    /// rather than `@ObservedObject` for `viewModel: ViewModel`.
    var __viewModelWitness: StateObject<ViewModel> { get }
}
