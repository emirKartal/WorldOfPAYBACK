//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(ProcessInfo.processInfo.environment["base-url"] ?? "")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
