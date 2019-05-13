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
    
    func getPath() -> String {
        switch self {
        case .flexList: return "flex/"
        }
    }
}
