//
//  TermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

protocol TermsOfServiceViewModel: ObservableObject {
    var finishedReading: Bool { get set }
    func didAcceptTermsOfService()
}
