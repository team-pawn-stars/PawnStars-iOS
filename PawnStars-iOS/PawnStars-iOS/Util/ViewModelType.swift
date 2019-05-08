//
//  ViewModelType.swift
//  PawnStars-iOS
//
//  Created by daeun on 02/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
