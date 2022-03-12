//
//  Checkbox.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Styleguide

public struct Checkbox: View {
    
    private let label: String
    @Binding private var isOn: Bool
    
    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
                .font(.zhip.title)
                .foregroundColor(.white)
        }
        .toggleStyle(CheckboxToggleStyle())
    }
}

    
public struct CheckboxToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image(
                systemName: configuration.isOn ? "checkmark.square" : "square"
            )
            .resizable()
            .frame(size: 22)
            .foregroundColor(Color.turquoise)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
            
            configuration.label
            Spacer()
        }
    }
}

