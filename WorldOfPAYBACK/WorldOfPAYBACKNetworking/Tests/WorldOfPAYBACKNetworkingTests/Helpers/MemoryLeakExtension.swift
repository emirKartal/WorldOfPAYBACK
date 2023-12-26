//
//  File.swift
//  
//
//  Created by emir kartal on 25.12.2023.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject,
                            file: StaticString = #filePath,
                            line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
