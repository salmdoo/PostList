//
//  HttpSetting.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
}

protocol API {
    var url: String { get }
    var method: HTTPMethod { get }
}

enum RequestError: Error, Equatable {
    static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidURL
    case noData
    case decodingFailed(_ error: Error)
}

protocol APIRequestProtocol {
    func fetchData<T: Decodable>(_ api: API) -> AnyPublisher<[T], RequestError>
}

struct APIRequest: APIRequestProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData<T>(_ api: API) -> AnyPublisher<[T], RequestError> where T : Decodable {
        guard let url =  URL(string: api.url) else {
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map(\.data)
            .decode(type: [T].self, decoder: JSONDecoder())
            .mapError { error in
                RequestError.decodingFailed(error)
            }
            .eraseToAnyPublisher()
    }
}
