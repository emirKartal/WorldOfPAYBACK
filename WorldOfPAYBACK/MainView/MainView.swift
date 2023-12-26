//
//  MainView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TransactionsView()
                .tabItem {
                    Image(systemName: "eurosign.arrow.circlepath")
                    Text("Transactions")
                }
            FeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }
            OnlineShoppingView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Shopping")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MainView()
}
