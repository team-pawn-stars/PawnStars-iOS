//
//  PawnListConnectModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 26/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PawnListConnectModel {
    let orderBy = BehaviorRelay<String>(value: "new")
    let category = BehaviorRelay<String>(value: "all")
    let region = BehaviorRelay<String>(value: "서울")
}
