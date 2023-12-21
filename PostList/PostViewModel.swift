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
        postService.getAllPost()
    }
    
    func fetchPosts(){
        postService.getAllPost()
            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: {_ in  }, 
//                  receiveValue: { [weak self] data in
//                self?.posts = data
//                print("self?.posts")
//            })
            .sink(receiveCompletion: { _ in }) { data in
                            self.posts = data
                print("self?.posts")
                        }
            .store(in: &cancellables)
    }
    
}
