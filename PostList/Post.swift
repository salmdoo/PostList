//
//  Post.swift
//  PostList
//
//  Created by Salmdo on 12/21/23.
//

import Foundation

struct Post: Identifiable, Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    var postedBy: String {
        return "Posted By User \(self.userId)"
    }
    
    static var previewObject: Post = Post(userId: 1, id: 1, title: "delectus ullam et corporis nulla voluptas sequi", body: "non et quaerat ex quae ad maiores\nmaiores recusandae totam aut blanditiis mollitia quas illo\nut voluptatibus voluptatem\nsimilique nostrum eum")
}
