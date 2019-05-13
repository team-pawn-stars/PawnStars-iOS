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
        let sortKey = BehaviorRelay<FlexSortKey>(value: .new)
            
        input.selectIndex.asObservable().subscribe { index in
            if let index = index.element {
                switch index {
                case 0: sortKey.accept(.new)
                case 1: sortKey.accept(.like)
                default: sortKey.accept(.new)
                }
            }
        }.disposed(by: disposeBag)
        
        let page = BehaviorRelay<Int>(value: 1)
        
        input.nextPage.asObservable().subscribe { _ in
            page.accept(page.value + 1)
        }.disposed(by: disposeBag)
        
        let flexList = self.api.flexList(page: page.value, sortKey: sortKey.value).asDriver(onErrorJustReturn: [])
        
        return Output(flexList: flexList)
    }
}
