//
//  iOSCommunicator.swift
//  GeokeyWatchApp Watch App
//
//  Created by Hamja Paldiwala on 20/02/24.
//

import Foundation
import WatchConnectivity

protocol iOSCommunicatorDelegate: AnyObject {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
}

class iOSCommunicator: NSObject {
    private static var instance = iOSCommunicator()
    public static var shared: iOSCommunicator {
        return instance
    }
    private(set) var session: WCSession?
    public weak var iOSDelegate: iOSCommunicatorDelegate?
}

extension iOSCommunicator {
    func config() {
//        guard WCSession.isSupported() else {
//            return print("Not supported")
//        }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
}

extension iOSCommunicator {
//    func sendDataToiPhone(data: [String: Any]) {
//        do {
//            try session?.updateApplicationContext(data)
//        } catch {
//            print("Error updating application context: \(error)")
//        }
//    }
    
    func sendDataToiPhone(video: ListViewModel.Video) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(video)
                session?.sendMessageData(data, replyHandler: nil, errorHandler: { error in
                    print("Error sending message to iPhone: \(error)")
                })
            } catch {
                print("Error encoding video object: \(error)")
            }
        }
}

extension iOSCommunicator: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        iOSDelegate?.session(session, activationDidCompleteWith: activationState, error: error)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            print("Received application context: \(applicationContext)")
        }
    }
}
