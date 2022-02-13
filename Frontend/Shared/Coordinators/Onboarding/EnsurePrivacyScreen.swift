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



struct CallToAction: View {
    struct Choice {
        let call: String
        let action: () -> Void
    }
    let primary: Choice
    let secondary: Choice?
    
    @ViewBuilder
    private var primaryView: some View {
        Button(primary.call) {
            primary.action()
        }.buttonStyle(.primary)
    }
    
    @ViewBuilder
    private var secondarView: some View {
        if let secondary = secondary {
            Button(secondary.call) {
                secondary.action()
            }.buttonStyle(.secondary)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        VStack {
            primaryView
            secondarView
        }
        
    }
}

struct EnsurePrivacyScreen<ViewModel: EnsurePrivacyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ForceFullScreen {
            VStack {
                Image("Icons/Large/Shield")
                
                Labels(
                    title: "Security",
                    subtitle: "Make sure ethat you are in a private space where no one can see/record your personal data. Avoid public places, cameras and CCTV's"
                )
 
                CallToAction(
                    primary: .init(
                        call: "My screen is not being watched",
                        action: viewModel.privacyIsEnsured
                    ),
                    secondary: .init(
                        call: "My screen might be watched",
                        action: viewModel.myScreenMightBeWatched
                    )
                )
            }
        }
    }
}
