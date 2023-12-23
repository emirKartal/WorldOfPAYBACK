//
//  File.swift
//  
//
//  Created by emir kartal on 23.12.2023.
//

import Foundation

struct RootTransactionModel: Decodable {
    let items: [TransactionModel]
}

struct TransactionModel: Decodable {
    let partnerDisplayNAme: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    
    struct Alias: Decodable {
        let reference: String
    }
    
    struct TransactionDetail: Decodable {
        let description: String
        let bookingDate: String
        let value: TransactionValue
        
        struct TransactionValue: Decodable {
            let amount: Int
            let currency: String
        }
    }
}
