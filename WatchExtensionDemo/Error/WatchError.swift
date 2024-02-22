//
//  WatchError.swift
//  WatchExtensionDemo
//
//  Created by PinalKumar on 19/02/24.
//

import Foundation

public enum WatchError: Error {
    case notSupported
    case sessionNotFound
    
}

extension WatchError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notSupported:
            return "Your device is not supported"
        case .sessionNotFound:
            return "Connectivity between iPhone to watch not found!"
        }
    }
}

extension WatchError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(description, comment: "")
    }
}
