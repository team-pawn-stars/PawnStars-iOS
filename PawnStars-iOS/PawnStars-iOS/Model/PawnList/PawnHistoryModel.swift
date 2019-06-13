//
//  PawnHistoryModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 05/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct PawnHistoryModel: Codable {
    let historyId: Int
    let pawnPostId: Int
    let date: String
    let content: String
    
    enum CodingKeys: String,CodingKey {
        case historyId = "id"
        case pawnPostId = "pawn_post_id"
        case date
        case content
    }
}
