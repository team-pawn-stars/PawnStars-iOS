//
//  IsSellerModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 23/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct IsSellerModel: Codable {
    let isSeller: Bool
    
    enum CodingKeys: String, CodingKey {
        case isSeller = "is_seller"
    }
}
