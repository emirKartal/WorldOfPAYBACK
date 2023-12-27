//
//  LoaderView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.0, anchor: .center)
                .progressViewStyle(.circular)
                .tint(.black)
        }
    }
}

#Preview {
    LoaderView()
}
