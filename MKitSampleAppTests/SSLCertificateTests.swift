//
//  SSLCertificateTests.swift
//  MKitSampleAppTests
//
//  Created by Martin Prusa on 4/30/20.
//  Copyright © 2020 Martin Prusa. All rights reserved.
//

import XCTest
import MKit

class SSLCertificateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSSLCreate() throws {
        let certificate = SSLCertificate(fileName: "martinprusa", suffix: "der")
        XCTAssert(certificate != nil, "cannot create SSLCertificate")
    }

}
