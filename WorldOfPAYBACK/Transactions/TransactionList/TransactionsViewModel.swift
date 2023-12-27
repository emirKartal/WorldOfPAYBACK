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
    @Published var transactions: [TransactionPresentationModel] = []
    
    init(client: TransactionDataLoaderProtocol = TransactionDataLoader(client: URLSessionHTTPClient())) {
        self.client = client
    }
    
    func getTransactions() {
        client.simulateMockData()
            .delay(for: 1, scheduler: RunLoop.main)
            .sinkToResult { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(let rootTransaction):
                    transactions = convertToPresentationModel(rootTransaction.sortedItems)
                case .failure:
                    break
                }
            }
            .store(in: &cancelBag)
    }
    
    private func convertToPresentationModel(_ modelList: [TransactionModel]) -> [TransactionPresentationModel] {
        modelList.map{ TransactionPresentationModel(id: UUID(), 
                                                    partnerDisplayName: $0.partnerDisplayName,
                                                    category: $0.category,
                                                    transactionDetailDescription: $0.transactionDetail.description,
                                                    transactionDetailBookingDate: $0.transactionDetail.bookingDate,
                                                    amount: $0.transactionDetail.value.amount,
                                                    currency: $0.transactionDetail.value.currency )}
    }
    
}
