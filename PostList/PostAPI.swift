//
//  PostAPI.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation

struct PostAPIEndpoint {
    static let domain = "https://jsonplaceholder.typicode.com"
    static let getAllPost = "/post"
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
