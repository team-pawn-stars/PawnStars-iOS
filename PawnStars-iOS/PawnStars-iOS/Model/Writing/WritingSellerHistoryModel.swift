//
//  WritingSelelrImageModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 30/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct WritingSellerHistoryModel: Codable {
    let pawnPost: Int
    let histories: [History]
    
    enum CodingKeys: String, CodingKey {
        case pawnPost = "pawn_post"
        case histories
    }
}

struct History: Codable {
    let date: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case content
    }
}
