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
    func signUpBuyer(username: String, password: String,phoneNum: String, nickName: String) -> Observable<SignUpResult>
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
    
    func signUpBuyer(username: String, password: String,phoneNum: String, nickName: String) -> Observable<SignUpResult> {
        return connector.post(path: AccountAPI.signUpBuyer.getPath(), params: ["username":username,"password":password,"phone":phoneNum,"name":nickName], header: Header.Empty)
            .map{ (response, _) -> SignUpResult in
                dump(response)
                switch response.statusCode {
                case 201: return SignUpResult.success
                case 409: return SignUpResult.existId
                case 400: return SignUpResult.fail
                default: return SignUpResult.empty
                }
        }
    }
    
    func signUpSeller() -> Observable<Bool> {
        return Observable.just(false)
    }
}
