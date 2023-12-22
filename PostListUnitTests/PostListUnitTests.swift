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

    override func setUp() {
            super.setUp()
            URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testFetchDataSuccess() {
        // Arrange
        let mockData = "[{\"userId\":1,\"id\":1,\"title\":\"Post1\",\"body\":\"Body1\"}]".data(using: .utf8)!
        print("Mock Data: \(String(data: mockData, encoding: .utf8) ?? "Invalid JSON")")

            MockURLProtocol.mockResponseData = mockData

            let apiRequest = APIRequest(urlSession: URLSession.shared)

            // Act
            let expectation = XCTestExpectation(description: "Fetch data expectation")
            var result: [Post]?

            apiRequest.fetchData(PostAPI.getAllPost)
                .sink(receiveCompletion: { completion in
                    print(completion)
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error during decoding: \(error)")
                        XCTFail("Unexpected error: \(error)")
                    }
                    expectation.fulfill()
                }, receiveValue: { posts in
                    result = posts
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 1.0)

            // Assert
//            XCTAssertNotNil(result)
//            XCTAssertEqual(result?.count, 1)
//            XCTAssertEqual(result?.first?.id, 1)
//            XCTAssertEqual(result?.first?.title, "Post 1")
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
