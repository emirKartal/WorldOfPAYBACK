//
//  File.swift
//  
//
//  Created by emir kartal on 24.12.2023.
//

import Foundation
import Combine

public protocol TransactionDataLoaderProtocol {
    func getTransactions() -> AnyPublisher<RootTransactionModel, APIError>
}

public final class TransactionDataLoader: TransactionDataLoaderProtocol {

    private let client: HTTPClientProtocol

    public init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    public func getTransactions() -> AnyPublisher<RootTransactionModel, APIError> {
        return client.get(endpoint: TransactionEndpoints.transactions)
    }
}
