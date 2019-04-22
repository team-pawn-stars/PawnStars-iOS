//
//  PawnBuyerAPI.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 17/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

enum PawnBuyerAPI : API {
    case pawn
    
    func getPath() -> String {
        switch self {
        case .pawn:
            return "pawn"
        }
    }
}
