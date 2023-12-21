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
                LazyVStack (alignment: .leading, spacing: 20) {
                    Text(post.title.capitalized)
                        .font(.title)
                        .bold()
                    Text(post.body)
                    HStack {
                        Spacer()
                        Text(post.postedBy)
                            .font(.caption)
                            .italic()
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 10)
                
            )
        }
        }
    }
}

#Preview {
    PostListView(postServiceProtocol: PostService(apiRequetProtocol: APIRequest(urlSession: URLSession.shared), api: PostAPI.getAllPost))
}
