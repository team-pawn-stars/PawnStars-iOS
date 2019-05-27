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
                guard let strongSelf = self else {return Observable.of((SignInResult.failure,nil))}
                
                let (username, password) = pair
                return (strongSelf.api.signIn(username: username, password: password))
        }
        
        let result = request.map { [weak self] request -> SignInResult in
            guard let strongSelf = self else {return SignInResult.failure}
            let (result, _) = request
            
            if result == SignInResult.success {
                strongSelf.api.isSeller().subscribe { isSeller in
                    if let isSeller = isSeller.element {
                        if isSeller {
                            UserDefaults.standard.set("SELLER", forKey: "ROLE")
                        } else {
                            UserDefaults.standard.set("BUYER", forKey: "ROLE")
                        }
                    }
                }.disposed(by: strongSelf.disposeBag)
            }
            
            return result
        }.asDriver(onErrorJustReturn: .empty)
        
        let token = request.map { request -> String? in
            
            let (_, token) = request
            
            return token
            }.asDriver(onErrorJustReturn: nil)
    
        return Output(result: result, token: token)
    }
}
