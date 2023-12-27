//
//  MainView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var connectionChecker: InternetConnectionChecker
    @State private var showNetworkAlert = false
    
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
        }.onChange(of: connectionChecker.isConnected) { connection in
            showNetworkAlert = connection == false
        }
        .alert(isPresented: $showNetworkAlert) {
            Alert(
                title: Text("Internet Connection"),
                message: Text("Network connection seems to be offline. Please check your connection!"),
                dismissButton: .default(Text("Close"))
            )
        }
    }
}

#Preview {
    MainView()
}
