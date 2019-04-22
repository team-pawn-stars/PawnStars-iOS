//
//  PawnListViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 08/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PawnListViewModel : ViewModelType{
    struct Input {
        let cellSelected : Driver<IndexPath>
    }
    struct Output{
        let selectedDone : Driver<String>
    }
    
    func transform(input: PawnListViewModel.Input) -> PawnListViewModel.Output {
        <#code#>
    }
    
}


