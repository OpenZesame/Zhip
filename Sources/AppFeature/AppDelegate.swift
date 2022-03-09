//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-08.
//

import ComposableArchitecture

public enum AppDelegateAction: Equatable {
	case didFinishLaunching
	case didRegisterForRemoteNotifications(Result<Data, NSError>)
}
