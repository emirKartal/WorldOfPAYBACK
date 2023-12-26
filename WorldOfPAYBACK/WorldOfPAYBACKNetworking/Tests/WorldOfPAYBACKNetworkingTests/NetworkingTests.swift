//
//  NetworkingTests.swift
//  
//
//  Created by emir kartal on 25.12.2023.
//

import XCTest
import Combine
@testable import WorldOfPAYBACKNetworking

final class NetworkingTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = requestURL()
        let exp = expectation(description: "loading")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        let sut = makeSUT(baseURL: "https://api-test.payback.com")
        let publisher: AnyPublisher<RootTransactionModel, APIError> = sut.get(endpoint: TransactionEndpoints.transactions)
        publisher
            .sinkToResult { _ in }
            .store(in: &cancelBag)
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(baseURL: String, file: StaticString = #filePath, line: UInt = #line) -> HTTPClientProtocol {
        let sut = URLSessionHTTPClient(baseURL: baseURL)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func requestURL() -> URL {
        URL(string: "https://api-test.payback.com/transactions")!
    }
    
    private func anyError() -> APIError {
        APIError.requestFailed("Failed")
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: APIError?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: APIError?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequest(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
        
    }
}
