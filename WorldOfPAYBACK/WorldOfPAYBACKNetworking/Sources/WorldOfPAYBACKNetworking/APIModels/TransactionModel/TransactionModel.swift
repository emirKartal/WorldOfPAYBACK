//
//  File.swift
//  
//
//  Created by emir kartal on 24.12.2023.
//

import Foundation

public struct RootTransactionModel: Decodable {
    public let items: [TransactionModel]
    public var sortedItems: [TransactionModel] {
        items.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
    }
}

public struct TransactionModel: Decodable {
    public let partnerDisplayName: String
    public let alias: Alias
    public let category: Int
    public let transactionDetail: TransactionDetail

    public struct Alias: Decodable {
        public let reference: String
    }

    public struct TransactionDetail: Decodable {
        public let description: String?
        public let bookingDate: Date
        public let value: TransactionValue

        public struct TransactionValue: Decodable {
            public let amount: Int
            public let currency: String
        }
    }
}
