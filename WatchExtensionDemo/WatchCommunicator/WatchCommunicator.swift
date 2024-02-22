//
//  WatchCommunicator.swift
//  WatchExtensionDemo
//
//  Created by PinalKumar on 19/02/24.
//

import Foundation
import WatchConnectivity

protocol WatchCommunicatorDelegate: AnyObject {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
}

final class WatchCommunicator: NSObject {
    private static var instance = WatchCommunicator()
    public static var shared: WatchCommunicator {
        return instance
    }
    private(set) var session: WCSession?
    public weak var watchDelegate: WatchCommunicatorDelegate?
}

extension WatchCommunicator {
    func config() throws {
        guard WCSession.isSupported() else {
            throw WatchError.notSupported
        }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
}

extension WatchCommunicator {
    func sendDataToWatch(data: [String: Any]) {
        do {
            try session?.updateApplicationContext(data)
        } catch {
            print("Error updating application context: \(error)")
        }
    }
}

extension WatchCommunicator: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        watchDelegate?.session(session, activationDidCompleteWith: activationState, error: error)
    }
    
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        guard let objectData = applicationContext["objectData"] as? Data else {
//            return
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            let object = try decoder.decode(Video.self, from: objectData)
//            
//            // Now you have the decoded object
//            print("Received object: \(object)")
//        } catch {
//            print("Error decoding object: \(error)")
//        }
//    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        do {
            let decoder = JSONDecoder()
            let video = try decoder.decode(Video.self, from: messageData)
            print("Received video: \(video)")
        } catch {
            print("Error decoding video: \(error)")
        }
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        guard let objectData = message["objectData"] as? Data else {
//            return
//        }
//        do {
//            let decoder = JSONDecoder()
//            let video = try decoder.decode(Video.self, from: objectData)
//            print("Received video: \(video)")
//        } catch {
//            print("Error decoding video: \(error)")
//        }
//    }
    
    struct Video: Identifiable, Codable {
        var id = UUID()
        let sectionId: Int
        let parentId: Int?
        let imageName: String
        let title: String
        var isExpanded: Bool?
        var isHeader: Bool
        var isVisible: Bool
    }
}
