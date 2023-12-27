//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import SwiftUI

struct TransactionDetailView: View {
    let viewModel: TransactionDetailViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.partnerName)
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(20)
                Text(viewModel.description ?? "")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(partnerName: "partner", description: "desc"))
}
