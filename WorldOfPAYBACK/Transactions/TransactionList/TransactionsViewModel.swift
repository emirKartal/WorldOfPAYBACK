//
//  TransactionsViewModel.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import Foundation
import Combine
import WorldOfPAYBACKNetworking

class TransactionsViewModel: ObservableObject {
    
    private let client: TransactionDataLoaderProtocol
    private var cancelBag = Set<AnyCancellable>()
    private var unFilteredTransactions: [TransactionPresentationModel] = []
    
    @Published var transactions: [TransactionPresentationModel] = []
    @Published var transactionsTotal: String = ""
    @Published var showError: APIError?
    @Published var isLoading: Bool = false
    
    init(client: TransactionDataLoaderProtocol = TransactionDataLoader(client: URLSessionHTTPClient())) {
        self.client = client
    }
    
    // Public Functions
    func getTransactions() {
        isLoading = true
        client.simulateMockData()
            .delay(for: 1, scheduler: RunLoop.main)
            .sinkToResult { [weak self] result in
                self?.isLoading = false
                guard let self else {return}
                switch result {
                case .success(let rootTransaction):
                    unFilteredTransactions = convertToPresentationModel(rootTransaction.sortedItems)
                    transactions = unFilteredTransactions
                case .failure(let error):
                    showError = error
                }
            }
            .store(in: &cancelBag)
    }
    
    func showFilteredListWithTotal(with category: Int) {
        transactions = unFilteredTransactions.filter({ $0.category == category })
        transactionsTotal = calculateTotalOfList(list: transactions)
    }
    
    func clearFilter() {
        transactions = unFilteredTransactions
        transactionsTotal = ""
    }
    
    func callbackFrom(category: Int?) {
        guard let category else {
            clearFilter()
            return
        }
        showFilteredListWithTotal(with: category)
    }
    
    // Private Functions
    private func convertToPresentationModel(_ modelList: [TransactionModel]) -> [TransactionPresentationModel] {
        modelList.map{ TransactionPresentationModel(id: UUID(), 
                                                    partnerDisplayName: $0.partnerDisplayName,
                                                    category: $0.category,
                                                    transactionDetailDescription: $0.transactionDetail.description,
                                                    transactionDetailBookingDate: $0.transactionDetail.bookingDate,
                                                    amount: $0.transactionDetail.value.amount,
                                                    currency: $0.transactionDetail.value.currency )}
    }
    
    private func calculateTotalOfList(list: [TransactionPresentationModel]) -> String {
        let sum = list.map({ $0.amount }).reduce(0, +)
        guard sum > 0 else {
            return ""
        }
        return "\(sum) \(list.first?.currency ?? "")"
    }
    
}
