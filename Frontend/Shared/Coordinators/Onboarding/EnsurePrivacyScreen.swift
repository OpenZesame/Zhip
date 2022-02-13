//
//  EnsurePrivacyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

protocol EnsurePrivacyViewModel: ObservableObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

final class DefaultEnsurePrivacyViewModel<Coordinator: RestoreOrGenerateNewWalletCoordinator>: EnsurePrivacyViewModel {
    private unowned let coordinator: Coordinator
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
extension DefaultEnsurePrivacyViewModel {
    func privacyIsEnsured() {
        coordinator.privacyIsEnsured()
    }
    
    func myScreenMightBeWatched() {
        coordinator.myScreenMightBeWatched()
    }
}

struct EnsurePrivacyScreen<ViewModel: EnsurePrivacyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ForceFullScreen {
            Onboard(
                image: { Image("Icons/Large/Shield") },
                title: "Security",
                subtitle: "Make sure ethat you are in a private space where no one can see/record your personal data. Avoid public places, cameras and CCTV's",
                primaryAction: {
                    Button("My screen is not being watched") {
                        viewModel.privacyIsEnsured()
                    }
                },
                secondaryAction: {
                    Button("My screen might be watched") {
                        viewModel.myScreenMightBeWatched()
                    }
                }
            )
        }
    }
}
