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
                TransactionItemView(
                    itemCellModel: TransactionItemViewModel(
                        partnerName: transaction.partnerDisplayName,
                        description: transaction.transactionDetailDescription,
                        bookingDate: transaction.bookingDateString,
                        amount: transaction.amountWithCurreny))
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
