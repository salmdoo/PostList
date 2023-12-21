//
//  PostListView.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI

struct PostListView: View {
    @StateObject var postViewModel: PostViewModel
    
    init(postServiceProtocol: PostServiceProtocol) {
        self._postViewModel = StateObject(wrappedValue: PostViewModel(postService: postServiceProtocol))
    }
    
    
    var body: some View {
        ScrollView {
            ForEach(postViewModel.posts) { post in
                LazyVStack (spacing: 20) {
                    VStack (alignment: .leading, spacing: 10) {
                        Text(post.title.capitalized)
                            .font(.title)
                            .bold()
                        Text(post.body)
                        Text(post.postedBy)
                        //.frame(maxWidth: .infinity, alignment: .trailing)
                    }
            }
        }
        }
    }
}

#Preview {
    PostListView(postServiceProtocol: PostService(apiRequetProtocol: APIRequest(urlSession: URLSession.shared), api: PostAPI.getAllPost))
}
