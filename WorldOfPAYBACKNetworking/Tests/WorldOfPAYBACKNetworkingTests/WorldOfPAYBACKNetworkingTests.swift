import XCTest
import Combine
@testable import WorldOfPAYBACKNetworking

final class WorldOfPAYBACKNetworkingTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
    }
    
    func test_invalidBaseUrl_getInvalidUrlError() {
        let client = HTTPClientSpy()
        let sut = TransactionDataLoader(client: client)
        defer {
            trackForMemoryLeak(client)
            trackForMemoryLeak(sut)
        }
        sut.getTransactions()
            .sinkToResult { result in
                switch result {
                case .success:
                    XCTFail("Shouldnt get success result")
                case .failure(let error):
                    XCTAssertEqual(error, .invalidURL)
                }
            }
            .store(in: &cancelBag)
    }
    
    // MARK: Helpers
    
    private func createSUT() {
        
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        var baseURL: String
        init(baseURL: String = "") {
            self.baseURL = baseURL
        }
        func get<T>(endpoint: WorldOfPAYBACKNetworking.ServiceEndpointsProtocol) -> AnyPublisher<T, WorldOfPAYBACKNetworking.APIError> where T : Decodable {
            guard let mockData = endpoint.mockData, !baseURL.isEmpty else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            do {
                let transactionList = try Decoders.mainDecoder.decode(RootTransactionModel.self, from: mockData)
                return Just(transactionList as! T)
                        .setFailureType(to: APIError.self)
                        .eraseToAnyPublisher()
            } catch {
                return Fail(error: APIError.decodingFailed).eraseToAnyPublisher()
            }
        }
    }
}

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
