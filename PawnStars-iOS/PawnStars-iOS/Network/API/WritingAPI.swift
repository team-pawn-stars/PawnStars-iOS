//
//  WritingAPI.swift
//  PawnStars-iOS
//
//  Created by daeun on 29/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

public enum WritingAPI: API{
    
    case writePawn
    case writePawnImage
    case writePawnHistory
    case getPawnLike
    
    func getPath() -> String {
        switch self {
        case .writePawn: return "pawn/"
        case .writePawnImage: return "pawn/image/"
        case .writePawnHistory: return "pawn/history/"
        case .getPawnLike: return "pawn/like/"
        }
    }
}
