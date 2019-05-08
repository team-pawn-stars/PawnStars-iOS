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
import RxAlamofire
import Alamofire

enum SignInResult {
    case success
    case failure
    case empty
}

class SignInViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    let api = SignUpApi()
    
    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let clickLogin: Signal<Void>
    }
    
    struct Output {
        let result: Driver<SignInResult>
        let token: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
            .asObservable()
        
        let request = input.clickLogin
            .asObservable()
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest{ [weak self] pair -> Observable<(SignInResult,String?)> in
                
                let (username, password) = pair
                return (self?.api.signIn(username: username, password: password))!
        }
        
        let result = request.map { request -> SignInResult in
            
            let (result, _) = request
            
            return result
        }.asDriver(onErrorJustReturn: .empty)
        
        let token = request.map { request -> String? in
            
            let (_, token) = request
            
            return token
            }.asDriver(onErrorJustReturn: nil)
    
        return Output(result: result, token: token)
    }
}
