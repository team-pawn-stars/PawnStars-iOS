//
//  WritingBuyerListModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 13/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct WritingBuyerListModel: Codable {
    let postId: Int
    let price: String
    let like: String
    let photo: String
    let author: String
    let category: String
    let region: String
    let date: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case price
        case like
        case photo
        case author
        case category
        case region
        case date
        case title
    }
}
