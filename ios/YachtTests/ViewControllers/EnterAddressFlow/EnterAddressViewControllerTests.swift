//
//  EnterAddressViewControllerTests.swift
//  YachtTests
//
//  Created by Henry Minden on 8/24/22.
//

import XCTest
@testable import Yacht

class EnterAddressViewControllerTests: XCTestCase {

    var sut: EnterAddressViewController!
    
    override func setUpWithError() throws {
        sut = EnterAddressViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func parseAddressHandlesNetworkPrefix() throws {
        let codeWithPrefix = "ethereum:0x96242814208590C563AAFB6270d6875A12C5BC45"
        XCTAssertEqual(sut.parseAddressFromQR(code: codeWithPrefix), "0x96242814208590C563AAFB6270d6875A12C5BC45", "address parser should remove prefix")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
