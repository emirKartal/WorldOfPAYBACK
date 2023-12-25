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
        let (sut, _) = makeSUT(baseURL: "")
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
        let (sut, _) = makeSUT()
        
        sut.getTransactions()
            .sinkToResult { result in
                switch result {
                case .success(let rootTransaction):
                    let transactionItems = rootTransaction.items
                    XCTAssertEqual(transactionItems.count, 21)
                    XCTAssertEqual(transactionItems.first?.partnerDisplayName, "REWE Group")
                case .failure:
                    XCTFail("Shouldnt get failure result")
                }
            }
            .store(in: &cancelBag)
    }
    
    func test_apiCall_properCount() {
        let (sut, client) = makeSUT()
        
        sut.getTransactions()
            .sinkToResult { _ in}
            .store(in: &cancelBag)
        XCTAssertEqual(client.apiCallCount, 1)
    }
    
    func test_endpointProtocol() {
        let (sut, client) = makeSUT()
        sut.getTransactions()
            .sinkToResult { _ in}
            .store(in: &cancelBag)
        XCTAssertEqual(client.url, URL(string: "https://api-test.payback.com/transactions"))
        XCTAssertEqual(client.transactionEndpoint?.headers, [:])
        XCTAssertNil(client.transactionEndpoint?.parameter)
        XCTAssertEqual(client.transactionEndpoint?.method, .get)
    }
    
    // MARK: Helpers
    
    private func makeSUT(baseURL: String = "https://api-test.payback.com") -> (sut: TransactionDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(baseURL: baseURL)
        let sut = TransactionDataLoader(client: client)
        defer {
            trackForMemoryLeak(client)
            trackForMemoryLeak(sut)
        }
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        var baseURL: String
        var apiCallCount = 0
        var url: URL?
        var transactionEndpoint: WorldOfPAYBACKNetworking.ServiceEndpointsProtocol?
        
        init(baseURL: String) {
            self.baseURL = baseURL
        }
        func get<T>(endpoint: WorldOfPAYBACKNetworking.ServiceEndpointsProtocol) -> AnyPublisher<T, WorldOfPAYBACKNetworking.APIError> where T : Decodable {
            apiCallCount += 1
            guard let mockData = endpoint.mockData, !baseURL.isEmpty else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            url = URL(string: "\(baseURL)")?.appendingPathComponent(endpoint.path)
            transactionEndpoint = endpoint
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
