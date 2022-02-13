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



struct CallToAction<PrimaryLabel: View, SecondaryLabel: View>: View {
    
    @ViewBuilder let primary: () -> Button<PrimaryLabel>
    @ViewBuilder let secondary: () -> Button<SecondaryLabel>?
 
    var body: some View {
        VStack {
            primary().buttonStyle(.primary)
            if let secondary = secondary {
                secondary().buttonStyle(.secondary)
            }
        }
        
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

struct Onboard<PrimaryLabel: View, SecondaryLabel: View>: View {

    @ViewBuilder let image: () -> Image?
    let title: String
    let subtitle: String
    @ViewBuilder let primaryAction: () -> Button<PrimaryLabel>
    @ViewBuilder let secondaryAction: () -> Button<SecondaryLabel>?
    
    init(
        @ViewBuilder image: @escaping () -> Image? = { nil },
        title: String,
        subtitle: String,
        @ViewBuilder primaryAction: @escaping () -> Button<PrimaryLabel>,
        @ViewBuilder secondaryAction: @escaping () -> Button<SecondaryLabel>? = { nil }
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        VStack {
            if let image = image {
                image()
            }
            Labels(
                title: title,
                subtitle: subtitle
            )
            
            CallToAction<PrimaryLabel, SecondaryLabel>(
                primary: primaryAction,
                secondary: secondaryAction
            )
        }
    }
}
