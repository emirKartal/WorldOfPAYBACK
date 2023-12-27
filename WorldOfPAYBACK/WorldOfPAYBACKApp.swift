//
//  WorldOfPAYBACKApp.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 23.12.2023.
//

import SwiftUI

@main
struct WorldOfPAYBACKApp: App {
    @StateObject var networkMonitor = InternetConnectionChecker()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(networkMonitor)
        }
    }
}
