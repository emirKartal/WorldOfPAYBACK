//
//  File.swift
//  
//
//  Created by emir kartal on 25.12.2023.
//

import Foundation

public enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol ServiceEndpointsProtocol {
    var path: String { get }
    var parameter: [URLQueryItem]? { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var mockData: Data? { get }
}

public enum TransactionEndpoints: ServiceEndpointsProtocol {
    case transactions
    
    public var path: String {
        switch self {
        case .transactions:
            return "transactions"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .transactions:
            return .get
        }
    }
    
    public var parameter: [URLQueryItem]? {
        switch self {
        case .transactions: return nil
        }
    }
    
    public var headers: [String : String] {
        return [:]
    }
    
    public var mockData: Data? {
        guard let url = Bundle.module.url(forResource: "PBTransactions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
