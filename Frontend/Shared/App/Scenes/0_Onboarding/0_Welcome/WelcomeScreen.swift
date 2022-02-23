//
//  WelcomeScreen.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI
import Stinsen

enum WelcomeNavigationStep {
    case didStart
}

protocol WelcomeViewModel: ObservableObject {
    func startApp()
}
extension WelcomeViewModel {
    typealias Navigator = NavigationStepper<WelcomeNavigationStep>
}

final class DefaultWelcomeViewModel: WelcomeViewModel {
    private unowned let navigator: Navigator
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    func startApp() {
        navigator.step(.didStart)
    }
}

struct WelcomeScreen<ViewModel: WelcomeViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Screen {
            foregroundView.background {
                backgroundView
            }
        }
    }
}

extension WelcomeScreen {
    
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
