//
//  NetworkManager.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

struct PostAPIEndpoint {
    static let domain = "https://jsonplaceholder.typicode.com"
    static let getAllPost = "/posts"
}


enum PostAPI: API {
    case getAllPost
    
    var domain: String {
        switch self {
        case .getAllPost:
            return PostAPIEndpoint.domain
        }
    }
    
    var path: String {
        switch self {
        case .getAllPost:
            return PostAPIEndpoint.getAllPost
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllPost:
            return HTTPMethod.get
        }
    }
}

protocol PostServiceProtocol {
    func getAllPost() -> AnyPublisher<[Post], RequestError>
}

struct PostService: PostServiceProtocol {
    private let apiRequestProtocol: APIRequestProtocol
    private let api: API
    
    init(apiRequetProtocol: APIRequestProtocol, api: API) {
        self.apiRequestProtocol = apiRequetProtocol
        self.api = api
    }
    
    func getAllPost() -> AnyPublisher<[Post], RequestError> {
        return apiRequestProtocol.request(api)
    }
    
    
}
