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
                    Text("transactionsString")
                }
            FeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("feedsString")
                }
            OnlineShoppingView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("shoppingString")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("settingsString")
                }
        }.onChange(of: connectionChecker.isConnected) { connection in
            showNetworkAlert = connection == false
        }
        .alert(isPresented: $showNetworkAlert) {
            Alert(
                title: Text("internetConnectionAlertTitleString"),
                message: Text("internetConnectionAlertMessageString"),
                dismissButton: .default(Text("Close"))
            )
        }
    }
}

#Preview {
    MainView()
}
