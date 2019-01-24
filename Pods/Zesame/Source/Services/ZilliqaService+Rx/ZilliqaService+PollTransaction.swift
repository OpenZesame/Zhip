//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
