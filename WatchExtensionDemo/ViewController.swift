//
//  ViewController.swift
//  WatchExtensionDemo
//
//  Created by Hamja Paldiwala on 16/02/24.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var txtmessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        do {
            WatchCommunicator.shared.watchDelegate = self
            try WatchCommunicator.shared.config()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnSendMessageClicked(_ sender: Any) {
        if let message = txtmessage.text {
            let sendmessage: [String: Any] = ["message": message]
            WatchCommunicator.shared.sendDataToWatch(data: sendmessage)
        }
    }
}

extension ViewController: WatchCommunicatorDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        print(error ?? "")
    }
}

