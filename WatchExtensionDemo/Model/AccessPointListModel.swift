//
//  AccessPointListModel.swift
//  WatchExtensionDemo
//
//  Created by PinalKumar on 19/02/24.
//

import Foundation

struct AccessPointListModel: Codable {
    let accountID: Int
    let accessPointList: [AccessPointModel]
}

struct AccessPointModel: Codable {
    let id: Int
    let name: String
}
