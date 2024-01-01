//
//  TransactionsView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import SwiftUI

struct TransactionsView: View {
    
    @StateObject private var viewModel: TransactionsViewModel = TransactionsViewModel()
    @State private var showCategories = false
    
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
                .refreshable {
                    viewModel.getTransactions()
                }
                LoaderView().hidden(!viewModel.isLoading)
            }
            .navigationTitle("transactionsString")
            .toolbar {
                TotalView(total: $viewModel.transactionsTotal)
                    .hidden(viewModel.transactionsTotal.isEmpty)
                Button {
                    self.showCategories.toggle()
                } label: {
                    Image(systemName: "slider.vertical.3")
                }
                .padding(.trailing, 5)
                .sheet(isPresented: $showCategories, content: {
                    CategoriesView(categories: viewModel.categories,
                                   onDismiss: viewModel.callbackFrom)
                })
            }
            .apiErrorAlert(error: $viewModel.showError)
        }
    }
}

#Preview {
    TransactionsView()
}
