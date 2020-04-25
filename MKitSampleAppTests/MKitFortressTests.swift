//
//  MKitSampleAppTests.swift
//  MKitSampleAppTests
//
//  Created by Martin Prusa on 4/24/20.
//  Copyright © 2020 Martin Prusa. All rights reserved.
//

import XCTest
@testable import MKitSampleApp
@testable import MKit

final class MKitFortressTests: XCTestCase {
    let account = "com.martinprusa.MKitSampleApp"
    let testValue = "Lorem ipsum^@!?_-45"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFortressOverall() throws {
        do {
            try testFortressSave()
            try testFortressLoad()
            try testFortressDelete()
        } catch {
            XCTAssert(false, "Fortress fails to save, load, delete")
        }
    }

    func testFortressSave() throws {
        do {
            let pwdValue = try GenericSecureValue.init(string: testValue)
            let status = try Fortress.shared.save(genericValue: pwdValue, account: account)
            XCTAssert(status == errSecSuccess, "cant store it")
        } catch  {
            XCTAssert(false, "cant store it")
        }
    }

    func testFortressLoad() throws {
        do {
            guard let value: GenericSecureValue = try Fortress.shared.value(account: account), let stringVal = String(data: value.dataValue, encoding: .utf8), stringVal == testValue else {
                XCTAssert(false, "cant read it")
                return
            }

            print("\(stringVal) loaded")
        } catch  {
            XCTAssert(false, "cant read it")
        }
    }

    func testFortressDelete() throws {
        do {
            try Fortress.shared.delete(account: account)
        } catch {
            XCTAssert(false, "cant delete it")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            try! testFortressOverall()
        }
    }
}
