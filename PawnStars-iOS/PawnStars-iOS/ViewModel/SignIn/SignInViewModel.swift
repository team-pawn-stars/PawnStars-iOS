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

enum SignInResult {
    case success
    case failure
    case empty
}

class SignInViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    
    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let clickLogin: Signal<Void>
    }
    
    struct Output {
        let result: Driver<SignInResult>
    }
    
    func transform(input: Input) -> Output {
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1 )}
            .asObservable()
        
        let result = input.clickLogin
            .asObservable()
            .withLatestFrom(usernameAndPassword)
        
        
        
        return Output(result: result)
    }
}
