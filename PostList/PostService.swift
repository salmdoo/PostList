//
//  NetworkManager.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

struct APIEndpoint {
    private static let domain = "https://jsonplaceholder.typicode.com"
    static let getAllPost = "\(domain)/posts"
}


enum PostAPI: API {
    case getAllPost
    
    var url: String {
        switch self {
        case .getAllPost:
            return APIEndpoint.getAllPost
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllPost:
            return HTTPMethod.get
        }
    }
}

protocol ServiceProtocol {
    func getAllPost() -> AnyPublisher<[Post], RequestError>
}

struct PostService: ServiceProtocol {
    private let apiRequestProtocol: APIRequestProtocol
    private let api: API
    
    init(apiRequetProtocol: APIRequestProtocol, api: API) {
        self.apiRequestProtocol = apiRequetProtocol
        self.api = api
    }
    
    func getAllPost() -> AnyPublisher<[Post], RequestError> {
        return apiRequestProtocol.fetchData(api)
    }
    
    
}
