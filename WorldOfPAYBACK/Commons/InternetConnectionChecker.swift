//
//  InternetConnectionChecker.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import Foundation
import Network

class InternetConnectionChecker: ObservableObject {
    private let connectionChecker = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Internet Connection Queue")
    var isConnected = false

    init() {
        connectionChecker.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        connectionChecker.start(queue: workerQueue)
    }
}
