//
//  SignUpViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let clickBuyer: Signal<Void>
        let clickPawn: Signal<Void>
        let clickNext: Signal<Void>
    }
    
    struct Output {
        let buyerColor: Driver<Bool>
        let pawnColor: Driver<Bool>
        let moveNextPage: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let clickBuyer = input.clickBuyer.asObservable().map{"BUYER"}
        let clickPawn = input.clickPawn.asObservable().map{"PAWN"}
        
        let buyerAndPawn = Observable.of(clickBuyer,clickPawn).merge()
        
        
        let buyerColor = buyerAndPawn.map{ role in
            if role == "BUYER" { return true }
            else { return false }
            }.asDriver(onErrorJustReturn: false)
        
        let pawnColor = buyerAndPawn.map{ role in
            if role == "PAWN" { return true }
            else { return false }
            }.asDriver(onErrorJustReturn: false)
        
        let moveNextPage = input.clickNext
            .map{ return true }
            .asDriver(onErrorJustReturn: false)
        
        
        return Output(buyerColor: buyerColor, pawnColor: pawnColor, moveNextPage: moveNextPage)
    }
}
