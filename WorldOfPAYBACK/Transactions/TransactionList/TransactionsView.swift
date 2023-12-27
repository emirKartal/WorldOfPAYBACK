//
//  TransactionsView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import SwiftUI

struct TransactionsView: View {
    
    @StateObject private var viewModel: TransactionsViewModel = TransactionsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.transactions, id: \.id) { transaction in
                VStack {
                    HStack {
                        Text(transaction.partnerDisplayName)
                            .fontWeight(.bold)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .lineLimit(1)
                        Text(transaction.amountWithCurreny)
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text(transaction.transactionDetailDescription ?? "")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        Text(transaction.bookingDateString)
                            .font(.system(size: 13))
                    }
                }
            }
            .navigationTitle("Transactions")
        }
        .onAppear(perform: {
            viewModel.getTransactions()
        })
    }
}

#Preview {
    TransactionsView()
}
