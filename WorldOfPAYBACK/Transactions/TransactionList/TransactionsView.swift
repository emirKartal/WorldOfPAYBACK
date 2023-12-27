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
            ZStack {
                List(viewModel.transactions, id: \.id) { transaction in
                    NavigationLink {
                        TransactionDetailView(
                            viewModel: TransactionDetailViewModel(
                                partnerName: transaction.partnerDisplayName,
                                description: transaction.transactionDetailDescription))
                    } label: {
                        TransactionItemView(
                                itemCellModel: TransactionItemViewModel(
                                partnerName: transaction.partnerDisplayName,
                                description: transaction.transactionDetailDescription,
                                bookingDate: transaction.bookingDateString,
                                amount: transaction.amountWithCurreny))
                    }

                }
                LoaderView().hidden(!viewModel.isLoading)
            }
            .navigationTitle("Transactions")
            .apiErrorAlert(error: $viewModel.showError)
        }
        .onAppear(perform: {
            viewModel.getTransactions()
        })
    }
}

#Preview {
    TransactionsView()
}
