//
//  SignInViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 08/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    let signInModel: SignInModel
    let disposeBag = DisposeBag()
    
    let id: Variable<String>
    let pw: Variable<String>
    
    let login = PublishRelay<Void>()
    
    init() {
        self.signInModel = SignInModel()
        self.id = signInModel.id
        self.pw = signInModel.pw
        
        login
            .subscribe(onNext: { [weak self] _ in
                //todo request to server
            }).disposed(by: disposeBag)
        
    }
}
