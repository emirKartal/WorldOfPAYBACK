//
//  TransactionPresentationModel.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import Foundation

struct RootTransactionPresentationModel {
    let transactions: [TransactionPresentationModel]
}

struct TransactionPresentationModel: Identifiable {
    let id: UUID
    let partnerDisplayName: String
    let category: Int
    let transactionDetailDescription: String?
    let transactionDetailBookingDate: Date
    let amount: Int
    let currency: String
}
