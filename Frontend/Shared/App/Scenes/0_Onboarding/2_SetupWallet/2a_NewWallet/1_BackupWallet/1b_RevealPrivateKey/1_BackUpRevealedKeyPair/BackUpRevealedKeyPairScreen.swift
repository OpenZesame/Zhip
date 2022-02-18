//
//  BackUpRevealedKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Zesame

protocol BackUpRevealedKeyPairViewModel: ObservableObject {}

final class DefaultBackUpRevealedKeyPairViewModel<Coordinator: BackUpKeyPairCoordinator>: BackUpRevealedKeyPairViewModel {
    private unowned let coordinator: Coordinator
    private let keyPair: KeyPair
    init(coordinator: Coordinator, keyPair: KeyPair) {
        self.coordinator = coordinator
        self.keyPair = keyPair
    }
}

struct BackUpRevealedKeyPairScreen<ViewModel: BackUpRevealedKeyPairViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension BackUpRevealedKeyPairScreen {
    var body: some View {
        Text("Back up keys")
    }
}
