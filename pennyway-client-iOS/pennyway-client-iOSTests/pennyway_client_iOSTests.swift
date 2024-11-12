//
//  pennyway_client_iOSTests.swift
//  pennyway-client-iOSTests
//
//  Created by 최희진 on 11/12/24.
//

import XCTest

final class pennyway_client_iOSTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testExample() throws {
        let data1 = 1
        let data2 = 1

        let result = data1 + data2

        XCTAssertEqual(result, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
