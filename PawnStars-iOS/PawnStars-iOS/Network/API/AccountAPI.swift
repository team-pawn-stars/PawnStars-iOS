//
//  AccountAPI.swift
//  PawnStars-iOS
//
//  Created by daeun on 17/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

public enum AccountAPI: API{
    
    case signIn
    case signUpBuyer
    case signUpSeller
    
    func getPath() -> String {
        switch self {
        case .signIn: return "signin/"
        case .signUpBuyer: return "signup/buyer/"
        case .signUpSeller: return "signup/seller/"
        }
    }
}
