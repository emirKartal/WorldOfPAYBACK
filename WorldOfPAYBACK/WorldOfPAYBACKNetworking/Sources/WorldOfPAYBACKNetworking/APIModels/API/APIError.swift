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
