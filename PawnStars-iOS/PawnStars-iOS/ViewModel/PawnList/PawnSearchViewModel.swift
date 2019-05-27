//
//  PawnSearchViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PawnSearchViewModel: ViewModelType {
    var connectModel: PawnListConnectModel!
    
    struct Input {
        let searchString: ControlProperty<String?>
    }
    
    struct Output {
        let searchList: Driver<[PawnListModel]>
    }
    
    struct Dependencies {
        let api: Api
    }
    
    init() {
        connectModel = PawnListConnectModel()
    }
    
    private let dependencies = Dependencies(api: Api())
    
    func transform(input: PawnSearchViewModel.Input) -> PawnSearchViewModel.Output {
        let items = input.searchString
            .asObservable()
            .distinctUntilChanged()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest {
                self.dependencies.api.PawnSearch(region: self.connectModel.region.value,
                                                 searchString: $0!)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(searchList: items)
    }
}
