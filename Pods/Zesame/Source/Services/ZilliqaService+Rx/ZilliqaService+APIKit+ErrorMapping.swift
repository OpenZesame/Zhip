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
import JSONRPCKit
import APIKit
import Result

typealias APIKitHandler<R> = (Result<R, APIKit.SessionTaskError>) -> Void
public typealias Done<R> = (Result<R, Zesame.Error>) -> Void

func mapHandler<R>(_ handler: @escaping Done<R>) -> APIKitHandler<R> {
    return { (result: Result<R, APIKit.SessionTaskError>) -> Void in
        switch result {
        case .failure(let apiKitError):
            handler(.failure(.api(Error.API(from: apiKitError))))
        case .success(let model): handler(.success(model))
        }
    }
}
