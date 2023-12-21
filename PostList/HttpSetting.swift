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
    var domain: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingFailed(_ error: Error)
}

protocol APIRequestProtocol {
    func request<T: Decodable>(_ api: API) -> AnyPublisher<T, APIError>
}

struct APIRequest: APIRequestProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func request<T>(_ api: API) -> AnyPublisher<T, APIError> where T : Decodable {
        guard let url =  URL(string: api.domain.appending(api.path)) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.noData
                }
                print(data)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                APIError.decodingFailed(error)
            }
            .eraseToAnyPublisher()
    }
    
    
}
