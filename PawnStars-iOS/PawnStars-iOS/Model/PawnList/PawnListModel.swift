//
//  PawnListModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 08/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct PawnListModel : Codable {
    let postId: Int
    let price: String
    let like: String
    let photo: String?
    let authorName: String
    let category: String
    let region: String
    let date: String
    let title: String
   
   
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case price
        case like
        case photo
        case authorName = "author"
        case category
        case region
        case date
        case title
    }
}
