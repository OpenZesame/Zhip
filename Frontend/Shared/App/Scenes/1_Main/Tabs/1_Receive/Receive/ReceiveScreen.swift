//
//  ReceiveScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import SwiftUI

struct ReceiveScreen: View {
    @ObservedObject var viewModel: ReceiveViewModel
}

extension ReceiveScreen {
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Labels(
                title: "My address",
                subtitle: viewModel.myActiveAddressFormatted
            )
            
            viewModel.qrCodeOfMyActiveAddress
        }
    }
}
