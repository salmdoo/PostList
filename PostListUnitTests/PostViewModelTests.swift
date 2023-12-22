//
//  PostViewModelTests.swift
//  PostListUnitTests
//
//  Created by Salmdo on 12/21/23.
//

import XCTest
import Combine
@testable import PostList

class MockService: ServiceProtocol {
    func getAllPost() -> AnyPublisher<[Post], RequestError> {
        // Provide a mock implementation of getAllPost for testing
        let mockData: [Post] = [Post(userId: 1, id: 1, title: "Title", body: "Body")]
        return Just(mockData)
            .setFailureType(to: Error.self)
            .mapError { error in
                RequestError.decodingFailed(error)
            }
            .eraseToAnyPublisher()
    }
}

final class PostViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    func testFetchPostsSuccess() {
        // Arrange
        let mockService = MockService()
        let viewModel = PostViewModel(service: mockService)

        // Act
        let expectation = XCTestExpectation(description: "Fetch posts expectation")

        viewModel.$posts
            .sink { posts in
                // Assert
                XCTAssertEqual(posts.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Wait for the asynchronous operation to complete
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPostsFailure() {
        // Arrange
        let mockService = MockService()
        // Modify the mockService to simulate a failure if needed

        let viewModel = PostViewModel(service: mockService)

        // Act
        let expectation = XCTestExpectation(description: "Fetch posts failure expectation")

        viewModel.$loadPostFailed
            .sink { loadPostFailed in
                // Assert
                XCTAssertFalse(loadPostFailed)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Wait for the asynchronous operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
}

