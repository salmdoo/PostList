//
//  NetworkManager.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

protocol PostServiceProtocol {
    func getAllPost() -> AnyPublisher<[Post], APIError>
}

struct PostService: PostServiceProtocol {
    private let apiRequestProtocol: APIRequestProtocol
    private let api: API
    
    init(apiRequetProtocol: APIRequestProtocol, api: API) {
        self.apiRequestProtocol = apiRequetProtocol
        self.api = api
    }
    
    func getAllPost() -> AnyPublisher<[Post], APIError> {
        return apiRequestProtocol.request(api)
//        print(res)
//        return res
    }
    
    
}
