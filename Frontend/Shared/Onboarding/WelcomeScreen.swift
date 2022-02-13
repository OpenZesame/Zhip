//
//  WelcomeScreen.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI
import Stinsen

protocol WelcomeViewModel: ObservableObject {
    func startApp()
}

final class DefaultWelcomeViewModel: WelcomeViewModel {
    private unowned let coordinator: OnboardingCoordinator
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    func startApp() {
        coordinator.didStart()
    }
}

struct WelcomeScreen<ViewModel: WelcomeViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        foregroundView.background {
            backgroundView
        }
    }
}

extension WelcomeScreen {
    
    var foregroundView: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Welcome!")
                    .font(.largeTitle)
                Text("Welcome to Zhip - the worlds first iOS wallet for Zilliqa.")
                
            }.foregroundColor(.white)
           
            Button("Start") {
                viewModel.startApp()
            }
            .buttonStyle(.primary)
        }
        .padding()
    }
  
    
    var backgroundView: some View {
        ParallaxImage(
            back: "Images/Welcome/BackClouds",
            middle: "Images/Welcome/MiddleSpaceship",
            front: "Images/Welcome/FrontBlastOff"
        )
    }
}

struct ParallaxImage: View {
    
    let back: String
    let middle: String
    let front: String
    
    var body: some View {
        ZStack {
            image(\.back)
            image(\.middle)
            image(\.front)
        }.background(Color.deepBlue)
        
    }
    
    @ViewBuilder
    private func image(_ keyPath: KeyPath<Self, String>) -> some View {
        Image(self[keyPath: keyPath])
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}
