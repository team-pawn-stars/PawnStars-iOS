//
//  ViewModelType.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 15/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
