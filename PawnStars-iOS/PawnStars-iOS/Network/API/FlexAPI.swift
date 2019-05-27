//
//  FlexAPI.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

public enum FlexAPI: API{
    
    case flexList
    case flexDetail(postId: Int)
    case flexLike(postId: Int)
    case flexDelete(postId: Int)
    case flexComment
    
    func getPath() -> String {
        switch self {
        case .flexList: return "flex/"
        case .flexDetail(let postId): return "flex/\(postId)/"
        case .flexLike(let postId): return "flex/\(postId)/like/"
        case .flexDelete(let postId): return "flex/\(postId)/"
        case .flexComment: return "flex/comment/"
        }
    }
}

