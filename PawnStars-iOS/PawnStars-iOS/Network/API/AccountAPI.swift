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
    case isSeller
    
    func getPath() -> String {
        switch self {
        case .signIn: return "account/signin/"
        case .signUpBuyer: return "account/signup/buyer/"
        case .signUpSeller: return "account/signup/seller/"
        case .isSeller: return "account/is_seller/"
        }
    }
}
