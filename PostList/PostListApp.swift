//
//  PostListApp.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI

@main
struct PostListApp: App {
    var body: some Scene {
        WindowGroup {
            PostListView(postServiceProtocol: PostService(apiRequetProtocol: APIRequest(urlSession: URLSession.shared), api: PostAPI.getAllPost))
        }
    }
}
