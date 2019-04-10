//
//  SignUpModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpModel {
    let buyerColor = BehaviorRelay<Bool>(value: true)
    let pawnColor = BehaviorRelay<Bool>(value: false)
    let role = BehaviorRelay<String>(value: "BUYER")
}
