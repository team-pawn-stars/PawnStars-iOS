//
//  Api.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 17/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

protocol AccountProvider {
    func signIn(username: String, password: String) -> Observable<(SignInResult,String?)>
    func signUpBuyer() -> Observable<Bool>
    func signUpSeller() -> Observable<Bool>
}

class Api: AccountProvider {
    
    private let connector = Connector()
    
    func signIn(username: String, password: String) -> Observable<(SignInResult,String?)> {
        return connector.post(path: AccountAPI.signIn.getPath(), params: ["username": username,"password":password], header: Header.Empty)
            .map{ (response, data) -> (SignInResult,String?) in
            
                var signInResult = SignInResult.empty

                switch response.statusCode {
                case 200: signInResult = SignInResult.success
                case 400,401: signInResult = SignInResult.failure
                default: signInResult = SignInResult.empty
                }
                
                guard let model = try? JSONDecoder().decode(SignInModel.self, from: data) else {
                    return (signInResult,nil)
                }
                return (signInResult, model.token)
        }
    }
    
    func signUpBuyer() -> Observable<Bool> {
        return Observable.just(false)
    }
    
    func signUpSeller() -> Observable<Bool> {
        return Observable.just(false)
    }
}
