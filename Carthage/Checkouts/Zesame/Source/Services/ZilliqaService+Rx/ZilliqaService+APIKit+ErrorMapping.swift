//
//  DefaultZilliqaService+APIKit.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
