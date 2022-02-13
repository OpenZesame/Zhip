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
        VStack(alignment: .leading) {
            title.font(.largeTitle)
            subtitle
        }.foregroundColor(.white)
    }
}
