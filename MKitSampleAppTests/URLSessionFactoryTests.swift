//
//  URLSessionFactoryTests.swift
//  MKitSampleAppTests
//
//  Created by Martin Prusa on 4/30/20.
//  Copyright © 2020 Martin Prusa. All rights reserved.
//

import XCTest
import MKit
import Combine

class URLSessionFactoryTests: XCTestCase {
    var cancelable: AnyCancellable?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSSLPining() throws {
        let worker = InvoiceWorker()
        let expectation = XCTestExpectation(description: "Download invoice.martinprusa.com home page")
        cancelable = worker.invoicePublisher().sink(receiveCompletion: { completion in
            switch completion {
                case .failure(let e):
                    print(e.err?.localizedDescription)
                    XCTAssert(false, "ssl pinning failed")
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
            }
        }) { result in
            print("result: \(result)")
            if let dataNotNil = result.data {
                print("data - string: \(String(data: dataNotNil, encoding: .utf8) ?? "uknwown string")")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 300.0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

enum InvoiceEndpoint: EndpointTarget {
    case dummyLoad

    var serverUrlString: String {
        return "https://invoice.martinprusa.com"
    }

    public var urlString: String {
        return "/"
    }

    func requestFactoryConfigurator() -> URLRequestFactoryConfigurator {
        return baseRequestFactoryConfigurator()
    }
}

final class InvoiceWorker {
    init() { }

    func invoicePublisher() -> AnyPublisher<UrlResponseResource.ResultConstruct, UrlResponseResource.ErrorResponse> {
        let endpoint = InvoiceEndpoint.dummyLoad
        let requestConfig = endpoint.requestFactoryConfigurator()
        let request = URLRequestFactory.init(config: requestConfig).request
        let resource = UrlResponseResource(request: request, result: nil, isSslPinningEnabled: true)
        URLSessionFactory.shared.sslCertificate = SSLCertificate(fileName: "martinprusa", suffix: "der")
        return URLSessionFactory.shared.plainLoadPublisher(resource: resource)
    }
}
