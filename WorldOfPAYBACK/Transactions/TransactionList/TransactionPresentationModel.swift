//
//  TransactionPresentationModel.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 26.12.2023.
//

import Foundation

struct TransactionPresentationModel: Identifiable, Equatable {
    let id: UUID
    let partnerDisplayName: String
    let category: Int
    let transactionDetailDescription: String?
    let transactionDetailBookingDate: Date
    let amount: Int
    let currency: String
    
    var amountWithCurreny: String {
        "\(amount) \(currency)"
    }
    
    var bookingDateString: String {
        transactionDetailBookingDate.convertToString(format: .uiDateFormat)
    }
}
