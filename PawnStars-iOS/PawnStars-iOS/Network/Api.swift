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
    func statusCode(code : Int) -> StatusCode
}

protocol FlexProvider {
    func flexList(page: Int, sortKey: FlexSortKey) -> Observable<[FlexListModel]>
}

protocol ApiProvider : AccountProvider,FlexProvider { }

class Api : ApiProvider{
    private let connector = Connector()
    
    func statusCode(code: Int) -> StatusCode {
        switch code {
        case 200,201: return StatusCode.success
        default: return StatusCode.failure
        }
    }
    
    func flexList(page: Int, sortKey: FlexSortKey) -> Observable<[FlexListModel]> {
        return connector.get(path: FlexAPI.flexList.getPath(), params: ["page":page,"sort_key":sortKey.getKey()], header: .Empty).map{ [weak self] (response,data) -> ([FlexListModel]) in
            let response = self?.statusCode(code: response.statusCode) ?? StatusCode.failure
            
            switch response {
            case .success:
                guard let model = try? JSONDecoder().decode([FlexListModel].self, from: data) else {
                    print("ERROR")
                    return []
                }
                return model
            case .failure:
                return []
            }
        }
    }
}

protocol SignInProvider {
    func signIn(username: String, password: String) -> Observable<(SignInResult,String?)>
    func signUpBuyer(username: String, password: String,phoneNum: String, nickName: String) -> Observable<SignUpResult>
    func signUpSeller(username: String, password: String, phoneNum: String, nickName: String, lng: Float, lat: Float) -> Observable<SignUpResult>
}


class SignUpApi: SignInProvider {
    
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
                switch response.statusCode {
                case 201: return SignUpResult.success
                case 409: return SignUpResult.existId
                case 400: return SignUpResult.fail
                default: return SignUpResult.empty
                }
        }
    }
    
    func signUpSeller(username: String, password: String, phoneNum: String, nickName: String, lng: Float, lat: Float) -> Observable<SignUpResult> {
        return connector.post(path: AccountAPI.signUpSeller.getPath(), params: ["username":username,"password":password,"phone":phoneNum,"name":nickName,"longitude":lng,"latitude":lat], header: Header.Empty).map{ (response,_) -> SignUpResult in
            switch response.statusCode {
            case 201: return SignUpResult.success
            case 409: return SignUpResult.existId
            case 400: return SignUpResult.fail
            default: return SignUpResult.empty
            }
        }
    }
}
