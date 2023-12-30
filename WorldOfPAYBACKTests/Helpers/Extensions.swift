//
//  Extensions.swift
//  WorldOfPAYBACKTests
//
//  Created by emir kartal on 30.12.2023.
//

import XCTest

extension XCTestCase {
    public func trackForMemoryLeak(_ instance: AnyObject,
                            file: StaticString = #filePath,
                            line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}

