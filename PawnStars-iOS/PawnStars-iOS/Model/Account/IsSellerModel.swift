//
//  IsSellerModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 05/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct IsSellerModel: Codable {
    let isSeller: Bool
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case isSeller = "is_seller"
        case name
    }
}
