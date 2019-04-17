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
            .map{_ in return SignInResult.success}.asDriver(onErrorJustReturn: .failure)
        
        
        
        return Output(result: result)
    }
    
    
    func networking() -> Observable<Data?> {
        RxAlamofire.requestData(<#T##method: HTTPMethod##HTTPMethod#>, <#T##url: URLConvertible##URLConvertible#>, parameters: <#T##[String : Any]?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##[String : String]?#>)
    }
}
