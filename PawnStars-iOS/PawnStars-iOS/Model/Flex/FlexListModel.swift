//
//  FlexListModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct FlexListModel: Codable {
    let postId: Int
    let author: String
    let date: String
    let pawnPost: Int
    let like: String
    let photo: String?
    let price: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case author
        case date
        case pawnPost = "pawn_post"
        case like
        case photo
        case price
        case title
    }
}
