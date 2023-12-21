//
//  PostViewModel.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

@Observable
class PostViewModel {
    var posts: [Post] = []
    var loadPostFailed: Bool = false
    
    private let serviceProtocol: ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ServiceProtocol) {
        self.serviceProtocol = service
        fetchPosts()
    }
    
    func fetchPosts(){
        serviceProtocol.getAllPost()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.loadPostFailed = true
                        print("API Request failed: \(error)")
                    }
                }, receiveValue: { [weak self] data in
                    self?.posts = data
                })
                .store(in: &cancellables)
    }
    
}
