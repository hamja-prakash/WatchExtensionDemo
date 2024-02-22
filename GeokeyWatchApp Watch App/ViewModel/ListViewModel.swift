//
//  ListViewModel.swift
//  GeokeyWatchApp Watch App
//
//  Created by Hamja Paldiwala on 16/02/24.
//

import Foundation
import UIKit
import WatchConnectivity

class ListViewModel : ObservableObject {
    @Published var videos: [Video] = []
    @Published var isToastVisible: Bool = false
    var toastMessage: String = ""
    
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
    
    func showToast(_ message: String) {
        toastMessage = message
        isToastVisible = true
    }
    
    struct VideoList {
        static let topTen = [
            Video(sectionId: 1, parentId: nil, imageName: "wish-i-knew",
                  title: "9 Things I Wish",
                  isExpanded: false, isHeader: true, isVisible: true),
            
            Video(sectionId: 2, parentId: 1, imageName: "your-first-app",
                  title: "Swift - Build Your App", isHeader: false, isVisible: false),

            Video(sectionId: 3, parentId: 1, imageName: "wish-i-knew",
                  title: "9 Things I Wish", isHeader: false, isVisible: false),
            
            Video(sectionId: 4, parentId: 1, imageName: "your-first-app",
                  title: "Swift - Build Your App", isHeader: false, isVisible: false),
        ]
    }
    
    func setupiOSConnectivity() {
            iOSCommunicator.shared.config()
        }
}

extension ListViewModel {
    func expandSection(_ item: Video) {
        if let index = videos.firstIndex(where: { $0.id == item.id }) {
            videos[index].isExpanded?.toggle()
            let isVisible = videos[index].isExpanded ?? false
            videos.enumerated().forEach { index, tempVideo in
                if tempVideo.parentId == item.sectionId {
                    videos[index].isVisible = isVisible
                }
            }
        }
    }
}

extension ListViewModel: iOSCommunicatorDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        print(error ?? "")
    }
}
