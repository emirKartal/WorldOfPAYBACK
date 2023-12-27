//
//  File.swift
//  
//
//  Created by emir kartal on 25.12.2023.
//

import Foundation

public enum APIError: LocalizedError, Equatable {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
    
    public var errorDescription: String? {
        "Error"
    }
    
    public var failureReason: String? {
        switch self {
        case .decodingFailed:
            "An error occured once parsing data"
        case .requestFailed(let message):
            message
        case .invalidURL:
            "Invalid url"
        }
    }
    
    public var recoverySuggestion: String? {
        "Something went wrong!!!"
    }
}
