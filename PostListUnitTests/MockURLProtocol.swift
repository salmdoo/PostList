//
//  MockURLProtocol.swift
//  PostListUnitTests
//
//  Created by Salmdo on 12/21/23.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponseData: Data?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let mockError = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: mockError)
        } else if let mockResponseData = MockURLProtocol.mockResponseData {
            self.client?.urlProtocol(self, didLoad: mockResponseData)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
