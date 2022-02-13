//
//  Onboard.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

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

