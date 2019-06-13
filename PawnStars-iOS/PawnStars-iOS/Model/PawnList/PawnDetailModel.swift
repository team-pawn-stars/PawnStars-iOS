//
//  PawnDetailModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 04/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct PawnDetailModel: Codable {
    let postId: Int
    let histories: [PawnHistoryModel]
    let photos: [String]
    let isLiked: Bool
    let totalLike: String
    let price: String
    let category: String
    let region: String
    let date: String
    let title: String
    let content: String
    let author: String
    
    enum CodingKeys: String, CodingKey{
        case postId = "post_id"
        case histories
        case photos
        case isLiked = "liked"
        case totalLike = "like"
        case price
        case category
        case region
        case date
        case title
        case content
        case author
    }

}
