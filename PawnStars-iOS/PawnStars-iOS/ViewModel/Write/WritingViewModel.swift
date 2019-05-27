//
//  WritingViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 24/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WritingViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let role: BehaviorRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let role = BehaviorRelay<String>(value: "")
        let roleString = UserDefaults.standard.string(forKey: "ROLE") ?? ""
        role.accept(roleString)
        
        return Output(role: role)
    }
}
