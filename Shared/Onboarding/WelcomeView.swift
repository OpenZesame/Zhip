//
//  WelcomeView.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct ParallaxImage<Layers: View>: View {
    @ViewBuilder var layers: Layers
    
    var body: some View {
        ZStack {
          layers
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        ZStack {
            backgroundView
            foregroundView
        }
    }
}

extension WelcomeView {
    
    var backgroundView: some View {
        ZStack {
            Image("Images/Welcome/BackClouds")
            Image("Images/Welcome/MiddleSpaceship")
            Image("Images/Welcome/FrontBlastOff")
        }.background(Color.clear)
//        var spaceShipImage: some View {
//        }
    }
    
    var foregroundView: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Welcome!")
                    .font(.largeTitle)
                Text("Welcome to Zhip - the worlds first iOS wallet for Zilliqa.")
                
            }.foregroundColor(.white)
            Button("Start") {
                print("Button 'Start' pressed")
            }
            .buttonStyle(.primary)
        }
        .padding()
    }
  
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
