//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-11.
//

import CustomDump

extension NewPIN.Action: CustomDumpStringConvertible {
	public var customDumpDescription: String {
		switch self {
		case let .delegate(delegate):
			return delegate.customDumpDescription
		default: return String(describing: self)
		}
	}
}


extension NewPIN.Action.Delegate: CustomDumpStringConvertible {
	public var customDumpDescription: String {
		switch self {
		case let .finishedSettingUpPIN(pin):
			return ".finishedSettingUpPIN(\(pin))"
		case .skippedPIN:
			return ".skippedPIN"
		}
	}
}
