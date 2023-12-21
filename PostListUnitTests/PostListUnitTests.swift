//
//  PostListUnitTests.swift
//  PostListUnitTests
//
//  Created by Salmdo on 12/21/23.
//

import XCTest
import Combine
@testable import PostList

final class PostListUnitTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    override class func setUp() {
            super.setUp()
            URLProtocol.registerClass(MockURLProtocol.self)
    }

    override class func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testFetchDataSuccess() {
        // Arrange
        let mockData = "{\"userId\":1,\"id\":2,\"title\":\"Title\",\"body\":\"ItemBody\"}".data(using: .utf8)!
        MockURLProtocol.mockResponseData = mockData

        let apiRequest = APIRequest(urlSession: URLSession.shared)

        // Act
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        var result: [Post]?

        apiRequest.fetchData(PostAPI.getAllPost)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("")
                        XCTFail("Unexpected error: \(error)")
                    }
                    expectation.fulfill()
                }, receiveValue: { data in
                    result = data
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 1.0)

//            // Assert
            XCTAssertEqual(result?.count, 1)
            XCTAssertEqual(result?.first?.id, 1)
            XCTAssertEqual(result?.first?.title, "Item 1")
        }

    func testFetchDataFailure() {
        // Arrange
        MockURLProtocol.mockError = RequestError.invalidURL

        let apiRequest = APIRequest(urlSession: URLSession.shared)

        // Act
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        var receivedError: RequestError?

        apiRequest.fetchData(PostAPI.getAllPost)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure, but the publisher completed successfully.")
                case .failure(let error):
                    receivedError = error as? RequestError
                }
                expectation.fulfill()
            }, receiveValue: { (posts: [Post]) in
                XCTFail("Expected failure, but received a value.")
            })
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(receivedError, RequestError.invalidURL)
    }


}
