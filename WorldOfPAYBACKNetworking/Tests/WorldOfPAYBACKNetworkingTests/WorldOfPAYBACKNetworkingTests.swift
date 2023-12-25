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
        let sut = makeSUT(baseURL: "")
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
    
    func test_validUrl_getProperData() {
        let sut = makeSUT()
        sut.getTransactions()
            .sinkToResult { result in
                switch result {
                case .success(let rootTransaction):
                    let transactionItems = rootTransaction.items
                    XCTAssertEqual(transactionItems.count, 21)
                case .failure:
                    XCTFail("Shouldnt get failure result")
                }
            }
            .store(in: &cancelBag)
    }
    
    // MARK: Helpers
    
    private func makeSUT(baseURL: String = "https://api-test.payback.com/transactions") -> TransactionDataLoader {
        let client = HTTPClientSpy(baseURL: baseURL)
        let sut = TransactionDataLoader(client: client)
        defer {
            trackForMemoryLeak(client)
            trackForMemoryLeak(sut)
        }
        return sut
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
