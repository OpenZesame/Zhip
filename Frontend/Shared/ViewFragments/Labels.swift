//
//  Labels.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct Labels: View {
    
    let title: Text
    let subtitle: Text
    
    init(
        title: () -> Text,
        subtitle: () -> Text
    ) {
        self.title = title()
        self.subtitle = subtitle()
    }
    
    init(
        title: String,
        font titleFont: Font = Font.zhip.header,
        subtitle: String,
        font subtitleFont: Font = Font.zhip.body
    ) {
        self.init(
            title: { Text(title).font(titleFont) },
            subtitle: { Text(subtitle).font(subtitleFont) }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            title
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: false)
            
            subtitle
        }
    }
}

