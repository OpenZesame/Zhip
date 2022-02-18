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
    
    init(title: Text, subtitle: Text) {
        self.title = title
        self.subtitle = subtitle
    }
    init(title: String, subtitle: String) {
        self.init(title: Text(title), subtitle: Text(subtitle))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            title.font(.zhip.header).lineLimit(2).fixedSize(horizontal: false, vertical: false)
            subtitle.font(.body)
        }
    }
}
