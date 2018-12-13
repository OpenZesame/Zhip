//
//  ZilliqaService+PollTransaction.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ZilliqaService {
    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling, done: @escaping Done<TransactionReceipt>) {
        func poll(retriesLeft: Int, delay delayInSeconds: Int) {
            // Stop recursion with failure when retry count reached zero
            guard retriesLeft > 0 else {
                return done(.failure(Error.api(.timeout)))
            }

            let delay = DispatchTimeInterval.seconds(delayInSeconds)

            background(delay: delay) { [unowned self] in
                self.getStatusOfTransaction(id: id) {
                    if case .success(let pollResponse) = $0, let receipt = TransactionReceipt(for: id, pollResponse: pollResponse) {
                        return done(.success(receipt))
                    }

                    // Recursivly call self
                    poll(retriesLeft: retriesLeft - 1, delay: polling.backoff.add(to: delayInSeconds))
                }
            }
        }

        // Initiate recursive backing off polling
        poll(retriesLeft: polling.count.rawValue, delay: polling.initialDelay.rawValue)
    }
}

// MARK: - Private
private extension ZilliqaService {
    func getStatusOfTransaction(id: String, done: @escaping Done<StatusOfTransactionResponse>) {
        return apiClient.send(request: StatusOfTransactionRequest(transactionId: id), done: done)
    }
}
