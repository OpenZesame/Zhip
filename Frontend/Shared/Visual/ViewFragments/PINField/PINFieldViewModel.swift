//
//  PINFieldViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-03-05.
//

import SwiftUI
import Combine

// MARK: - PINFieldViewModel
// MARK: -
public final class PINFieldViewModel: ObservableObject {

    @Published var shakesLeft = 0
    
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - Public
// MARK: -
public extension PINFieldViewModel {
    
    /// We shake back and forth thus `shakeRepeatCount * 2`
    static let errorAnimationDuration = Double(shakeRepeatCount * 2) * durationPerShake
    
    func shake() {
        // Planned number of shakes back and forth,
        // View will when `shakesLeft = 0`
        shakesLeft = Self.shakeRepeatCount
        
        // decrease `shakesLeft` by 1 every `ViewModel.durationPerShake` sec
        Timer
            .publish(every: PINFieldViewModel.durationPerShake, on: RunLoop.main, in: .default)
            .autoconnect() // If we dont autoconnect, `Timer` will never fire.
            .sink(receiveValue: { [unowned self] _ in
                guard shakesLeft >= 0 else {
                    return cancelShaking()
                }
                shakesLeft -= 1
            })
            .store(in: &cancellables)
    }
}

// MARK: - Internal
// MARK: -
internal extension PINFieldViewModel {
    static let shakeRepeatCount = 4
    static let durationPerShake = 0.10
}

// MARK: - Private
// MARK: -
private extension PINFieldViewModel {
    
    func cancelShaking() {
        cancellables.forEach { $0.cancel() }
        cancellables = .init()
    }
}
