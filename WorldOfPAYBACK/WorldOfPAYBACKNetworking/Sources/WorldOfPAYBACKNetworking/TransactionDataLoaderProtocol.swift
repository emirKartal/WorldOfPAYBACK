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
        client.get(endpoint: TransactionEndpoints.transactions)
    }
    
    /// Use mock data until backend is ready!!!
    public func simulateMockData(endpoint: TransactionEndpoints) -> AnyPublisher<RootTransactionModel, APIError> {
        guard let mockData = endpoint.mockData else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        do {
            let transactionList = try Decoders.mainDecoder.decode(RootTransactionModel.self, from: mockData)
            return Just(transactionList)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.decodingFailed).eraseToAnyPublisher()
        }
    }
}
