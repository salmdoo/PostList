//
//  Post.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation

struct Post: Identifiable, Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    var postedBy: String? {
        userId != nil ? "Posted By User \(userId!)" : nil
    }
}
