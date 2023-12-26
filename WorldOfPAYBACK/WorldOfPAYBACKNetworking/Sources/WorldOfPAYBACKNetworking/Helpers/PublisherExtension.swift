//
//  File.swift
//  
//
//  Created by emir kartal on 25.12.2023.
//

import Foundation
import Combine

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Self.Output, Self.Failure>) -> Void) -> AnyCancellable {
        sink { completion in
            switch completion {
            case .failure(let error):
                result(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
}

