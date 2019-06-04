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
import RxOptional

class PawnSearchViewModel: ViewModelType {
    var connectModel: PawnListConnectModel!
    
    struct Input {
        let searchString: ControlProperty<String?>
        let cellSelected: Signal<IndexPath>
    }
    
    struct Output {
        let searchList: Driver<[PawnListModel]>
        let selectedDone: Driver<Int>
    }
    
    struct Dependencies {
        let api: Api
    }
    
    init() {
        connectModel = PawnListConnectModel()
    }
    
    private let dependencies = Dependencies(api: Api())
    
    func transform(input: PawnSearchViewModel.Input) -> PawnSearchViewModel.Output {
        let searchList = input.searchString
            .asObservable()
            .filterNil()
            .distinctUntilChanged()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest {
                self.dependencies.api.PawnSearch(region: self.connectModel.region.value,
                                                 searchString: $0)
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedDone = Observable.combineLatest(searchList.asObservable(), input.cellSelected.asObservable()) { (items, indexpath) in
            return items[indexpath.row]
            }.map {
                return $0.postId
            }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(searchList: searchList, selectedDone: selectedDone)
    }
}
