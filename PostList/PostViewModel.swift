//
//  PostViewModel.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let postService: PostServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(postService: PostServiceProtocol) {
        self.postService = postService
        fetchPosts()
    }
    
    func fetchPosts(){
        postService.getAllPost()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("API Request failed: \(error)")
                    }
                }, receiveValue: { [weak self] data in
                    self?.posts = data
                })
                .store(in: &cancellables)
    }
    
}
