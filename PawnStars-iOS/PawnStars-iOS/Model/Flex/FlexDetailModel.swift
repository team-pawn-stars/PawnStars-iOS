//
//  FlexDetailModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 17/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct FlexDetailModel: Codable {
    let postId: Int
    let comments: [Comment]
    let photos: [String]
    let liked: Bool
    let like: String
    let date: String
    let title: String
    let content: String
    let author: String
    let pawnPost: Int
    let price: String
    
    struct Comment: Codable {
        let commentId: Int
        let flexPostId: Int
        let authorId: String
        let date: String
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case commentId = "comment_id"
            case flexPostId = "flex_post_id"
            case authorId = "author_id"
            case date
            case content
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case comments
        case photos
        case liked
        case like
        case date
        case title
        case content
        case author
        case pawnPost = "pawn_post"
        case price
    }
}
