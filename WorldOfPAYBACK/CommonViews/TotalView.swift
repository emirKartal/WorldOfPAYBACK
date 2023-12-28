//
//  TotalView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 28.12.2023.
//

import SwiftUI

struct TotalView: View {
    @Binding var total: String
    
    var body: some View {
        Text(total)
            .font(.system(size: 12))
            .foregroundStyle(.white)
            .padding(5)
            .background(.blue.opacity(0.75), in: Capsule())
    }
}

#Preview {
    TotalView(total:.constant("1234 PBP"))
}
