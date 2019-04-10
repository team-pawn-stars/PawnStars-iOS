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

class SignUpViewModel {
    let signUpModel: SignUpModel
    let disposeBag = DisposeBag()
    
    let buyerColor: Observable<Bool>
    let pawnColor: Observable<Bool>
    let clickBuyer = PublishRelay<Void>()
    let clickPawn = PublishRelay<Void>()
    
    init() {
        signUpModel = SignUpModel()
        
        self.buyerColor = self.signUpModel.buyerColor.asObservable()
        self.pawnColor = self.signUpModel.pawnColor.asObservable()
        
        clickBuyer
            .subscribe(onNext: { [weak self] _ in
                self?.signUpModel.buyerColor.accept(true)
                self?.signUpModel.pawnColor.accept(false)
            }).disposed(by: disposeBag)
        
        clickPawn
            .subscribe(onNext: { [weak self] _ in
                self?.signUpModel.buyerColor.accept(false)
                self?.signUpModel.pawnColor.accept(true)
            }).disposed(by: disposeBag)
    }
}
