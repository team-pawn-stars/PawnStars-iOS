//
//  asd.swift
//  PawnStars-iOS
//
//  Created by daeun on 17/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

struct SignInModel: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
