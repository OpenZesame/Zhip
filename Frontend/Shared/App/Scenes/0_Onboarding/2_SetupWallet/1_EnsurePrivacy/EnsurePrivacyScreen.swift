//
//  EnsurePrivacyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

struct EnsurePrivacyScreen<ViewModel: EnsurePrivacyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension EnsurePrivacyScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                Image("Icons/Large/Shield")
                
                Labels(
                    title: "Security",
                    subtitle: "Make sure ethat you are in a private space where no one can see/record your personal data. Avoid public places, cameras and CCTV's"
                )
                
                CallToAction(
                    primary: {
                        Button("My screen is not being watched") {
                            viewModel.privacyIsEnsured()
                        }
                    },
                    secondary: {
                        Button("My screen might be watched") {
                            viewModel.myScreenMightBeWatched()
                        }
                    }
                )
            }
        }
    }
}
