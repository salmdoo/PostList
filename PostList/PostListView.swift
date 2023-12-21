//
//  PostListView.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI

struct PostListView: View {
    @State private var postViewModel: PostViewModel
    
    init(serviceProtocol: ServiceProtocol) {
        self._postViewModel = State(wrappedValue: PostViewModel(service: serviceProtocol))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack () {
                ForEach(postViewModel.posts) { post in
                    VStack (alignment: .leading, spacing: 20) {
                        if let title = post.title {
                            Text(title.capitalized)
                                .font(.title)
                                .bold()
                        }
                        
                        if let body = post.body {
                            Text(body)
                        }
                        if let postedBy = post.postedBy {
                            HStack {
                                Spacer()
                                Text(postedBy)
                                    .font(.caption)
                                    .italic()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(radius: 10)
                        
                    )
                }
            }
        }
        .alert("Important Message", 
               isPresented: $postViewModel.loadPostFailed,
               actions: {
                Button("Reload application") {
                    postViewModel.fetchPosts()
                }
        }, message: {
            Text("Please come back later")
        })
        .refreshable {
            postViewModel.fetchPosts()
        }
    }
}

#Preview {
    PostListView(serviceProtocol: PostService(apiRequetProtocol: APIRequest(), api: PostAPI.getAllPost))
}
