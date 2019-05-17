//
//  FlexViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FlexViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    let api = Api()
    
    struct Input {
        let selectIndex: Driver<Int>
        let nextPage: Signal<Void>
    }
    struct Output {
        let flexList: Driver<[FlexListModel]>
    }
    func transform(input: Input) -> Output {
        
        let sortKey = input.selectIndex.asObservable().flatMapLatest { index -> Observable<FlexSortKey> in
            switch index {
            case 0: return Observable.of(.new)
            case 1: return Observable.of(.like)
            default: return Observable.of(.new)
            }
        }
        
        let page = BehaviorRelay<Int>(value: 1)
        
        input.nextPage.asObservable().subscribe {
            page.accept(page.value + 1)
        }.disposed(by: disposeBag)
        
        let pageAndSortKey = Observable.combineLatest(page.asObservable(), sortKey) {($0,$1)}
        
        let flexList = pageAndSortKey.flatMapLatest { [weak self] pair -> Observable<[FlexListModel]> in
            guard let strongSelf = self else {return Observable.of([])}
            let (page,sortKey) = pair
            return strongSelf.api.flexList(page: page, sortKey: sortKey)
        }
        
        return Output(flexList: flexList.asDriver(onErrorJustReturn: []))
    }
}
