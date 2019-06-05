//
//  WritingPawnModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 29/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct WritingSellerModel: Codable {
    let postId: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
    }
}
