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
            PostListView(serviceProtocol: PostService(apiRequetProtocol: APIRequest(), api: PostAPI.getAllPost))
        }
    }
}
