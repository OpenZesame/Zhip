// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
