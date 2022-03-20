////
////  Balance.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-10.
////
//
//import SwiftUI
//import ZhipEngine
//import Styleguide
//
//struct BalancesScreen: View {
//    @ObservedObject var viewModel: BalancesViewModel
//}
//
//extension BalancesScreen {
//    var body: some View {
//        Labels(
//            title: "ZIL balance",
//            subtitle: viewModel.zilBalance
//        )
//        .refreshable {
//            await viewModel.fetchBalances()
//        }
//        .onAppear {
//            viewModel.fetchBalanceFireAndForget()
//        }
//    }
//}
