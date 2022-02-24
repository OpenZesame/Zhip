//
//  WelcomeScreen.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

// MARK: - WelcomeScreen
// MARK: -
struct WelcomeScreen: View {
    @ObservedObject var viewModel: WelcomeViewModel
}

// MARK: - View
// MARK: -
extension WelcomeScreen {
    var body: some View {
        Screen {
            foregroundView.background {
                backgroundView
            }
        }
    }
}

// MARK: - Subviews
// MARK: -
private extension WelcomeScreen {
    
    var foregroundView: some View {
        VStack {
            Spacer()
            
            Labels(
                title: "Welcome", font: .zhip.impression,
                subtitle: "Welcome to Zhip - the worlds first iOS wallet for Zilliqa."
            )
            
            Button("Start") {
                viewModel.startApp()
            }
            .buttonStyle(.primary)
        }.padding()
    }
  
    
    var backgroundView: some View {
        ParallaxImage(
            back: "Images/Welcome/BackClouds",
            middle: "Images/Welcome/MiddleSpaceship",
            front: "Images/Welcome/FrontBlastOff"
        )
    }
}
