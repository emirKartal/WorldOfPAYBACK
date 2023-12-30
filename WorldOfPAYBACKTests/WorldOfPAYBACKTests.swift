//
//  WorldOfPAYBACKTests.swift
//  WorldOfPAYBACKTests
//
//  Created by emir kartal on 23.12.2023.
//

import XCTest
import Combine
@testable import WorldOfPAYBACK

final class WorldOfPAYBACKTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
    }
    
    func test_transactionsViewModel_initValues() {
        let sut = makeSut()
        
        let categories = sut.categories
        let transactions = sut.transactions
        let transactionTotal = sut.transactionsTotal
        let error = sut.showError
        let isLoading = sut.isLoading
        
        XCTAssertEqual(categories, [])
        XCTAssertEqual(transactions, [])
        XCTAssertEqual(transactionTotal, "")
        XCTAssertNil(error)
    }
    
    func test_getItemWithMock_expectSuccessfulTransactionDataAndCategories() {
        let sut = makeSut()
        
        let exp = expectation(description: "loading")
        sut.$transactions
            .dropFirst()
            .sink(receiveValue: { [weak sut] in
                XCTAssertEqual($0.count, 21)
                XCTAssertEqual(sut?.categories, [1,2,3])
                exp.fulfill()
            })
            .store(in: &cancelBag)
        sut.getTransactions(random: true)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getItemWithMock_expectFalseTrueFalseStateOfLoading() {
        let sut = makeSut()
        
        let expectedResult = [true, false]
        var result: [Bool] = []
        let exp = expectation(description: "loading")
        
        sut.$isLoading
            .sink(receiveValue: {
                result.append($0)
                if result.count == 2 {
                    XCTAssertEqual(result, expectedResult)
                    exp.fulfill()
                }
            })
            .store(in: &cancelBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_callTransactions_expectFailure() {
        let sut = makeSut()
        
        let exp = expectation(description: "loading")
        sut.$showError
            .dropFirst()
            .sink(receiveValue: { error in
                guard let error else {
                    return XCTFail("Should create an error")
                }
                XCTAssertEqual(error.failureReason, "Error occured when getting data")
                exp.fulfill()
            })
            .store(in: &cancelBag)
        
        sut.getTransactions(random: false)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getItems_expectFilteredCategories() {
        let sut = makeSut()
        
        let exp1 = expectation(description: "loadingData")
        let exp2 = expectation(description: "filterData")
        sut.getTransactions(random: true)
        sut.$transactions
            .dropFirst()
            .sink(receiveValue: { [weak sut] in
                if $0.count == 21 {
                    XCTAssertEqual( $0.count, 21)
                    exp1.fulfill()
                    sut?.callbackFrom(category: 3)
                } else if $0.count == 1 {
                    XCTAssertEqual( $0.count, 1)
                    exp2.fulfill()
                }
            })
            .store(in: &cancelBag)
        
        
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }

    private func makeSut(file: StaticString = #filePath,
                         line: UInt = #line) -> TransactionsViewModel {
        let sut = TransactionsViewModel()
        defer { self.trackForMemoryLeak(sut, file: file, line: line) }
        return sut
    }
}
