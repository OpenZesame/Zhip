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

public enum ZilliqaAPIEndpoint {
    case mainnet
    case testnet
}

public extension ZilliqaAPIEndpoint {
    var baseURL: URL {
        let urlString: String
        switch self {
        // Testnet endpoint is unknown at this time, the url used
        // by the testnet before mainnet launch is the url that
        // will become the mainnet url in the future, and the
        // testnet will get its own
        case .mainnet, .testnet: urlString = "https://api.zilliqa.com"
        }

        guard let url = URL(string: urlString) else {
            fatalError("Incorrect implementation should be able to construct url")
        }

        return url
    }
}
