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
    
}

protocol PawnBuyer {
    func PawnList(category: String, sort_key: String, region: String) -> Observable<(StatusCode, [PawnListModel])>
    func PawnSearch(region: String, searchString: String) -> Observable<[PawnListModel]>
    func PawnDetail(postId: Int) -> Observable<PawnDetailModel?>
}


protocol FlexProvider {
    func flexList(page: Int, sortKey: FlexSortKey) -> Observable<[FlexListModel]>
    func flexDetail(postId: Int) -> Observable<FlexDetailModel?>
    func writeComment(flexPost: Int, content: String) -> Observable<Bool>
}

protocol ApiProvider: PawnBuyer, AccountProvider, FlexProvider {
    func statusCode(code : Int) -> StatusCode
}


class Api : ApiProvider {
    private let connector = Connector()
    
    func statusCode(code: Int) -> StatusCode {
        switch code {
        case 200,201: return StatusCode.success
        default: return StatusCode.failure
        }
    }
    
    func PawnList(category: String, sort_key: String, region: String) -> Observable<(StatusCode, [PawnListModel])> {
        return connector.get(path: PawnBuyerAPI.pawn.getPath(),
                             params: ["region" : region,
                                      "category": category,
                                      "sort_key": sort_key],
                             header: Header.Empty)
            .map { res,data -> (StatusCode, [PawnListModel]) in
                guard let response = try? JSONDecoder().decode([PawnListModel].self, from: data) else {
                    print("decode failure")
                    return (StatusCode.failure, [])
                }
                return (self.statusCode(code: res.statusCode), response)
        }
    }
    
    func PawnSearch(region: String, searchString: String) -> Observable<[PawnListModel]> {
        return connector.get(path: PawnBuyerAPI.pawn.getPath(),
                             params: ["region" : region,
                                      "query" : searchString], header: Header.Empty)
            .map { res,data -> [PawnListModel] in
                guard let response = try? JSONDecoder().decode([PawnListModel].self, from: data) else {
                    print("decode failure")
                    return []
                }
                return response
        }
    }
    
    func PawnDetail(postId: Int) -> Observable<PawnDetailModel?> {
        return connector.get(path: PawnBuyerAPI.pawnDetail(postId: postId).getPath(),
                             params: nil,
                             header: Header.Authorization)
            .map { [weak self] res, data -> PawnDetailModel? in
                guard let `self` = self else { return nil }
                
                switch self.statusCode(code: res.statusCode){
                case .success :
                    guard let response = try? JSONDecoder().decode(PawnDetailModel.self, from: data) else {
                        print("decode failure")
                        return nil }
                    return response
                case .failure: return nil
                }
        }
    }
    
    func flexList(page: Int, sortKey: FlexSortKey) -> Observable<[FlexListModel]> {
        return connector.get(path: FlexAPI.flexList.getPath(), params: ["page":page,"sort_key":sortKey.getKey()], header: .Authorization).map{ [weak self] (response,data) -> ([FlexListModel]) in
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
    
    func flexDetail(postId: Int) -> Observable<FlexDetailModel?> {
        return connector.get(path: FlexAPI.flexDetail(postId: postId).getPath(), params: nil, header: .Authorization).map { [weak self] (response, data) -> (FlexDetailModel?) in
            guard let strongSelf = self else {return nil}
            let response = strongSelf.statusCode(code: response.statusCode)
            
            switch response {
            case .success:
                guard let model = try? JSONDecoder().decode(FlexDetailModel.self, from: data) else {
                    print("ERROR")
                    return nil
                }
                return model
            case .failure:
                return nil
            }
        }
    }
    
    func writeComment(flexPost: Int, content: String) -> Observable<Bool> {
        return connector.post(path: FlexAPI.flexComment.getPath(), params: ["flex_post": flexPost, "content": content], header: .Authorization).map { [weak self] (response, data) -> Bool in
            guard let strongSelf = self else {return false}
            let response = strongSelf.statusCode(code: response.statusCode)
            switch response {
            case .success: return true
            case .failure: return false
            }
        }
    }
    
    func flexLike(postId: Int) -> Observable<Bool> {
        return connector.patch(path: FlexAPI.flexLike(postId: postId).getPath(), params: nil, header: .Authorization).map { [weak self] (response, data) -> Bool in
            guard let strongSelf = self else {return false}
            let response = strongSelf.statusCode(code: response.statusCode)
            switch response {
            case .success: return true
            case .failure: return false
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
    
    func isSeller() -> Observable<Bool> {
        return connector.get(path: AccountAPI.isSeller.getPath(), params: nil, header: .Authorization).map { (response, data) -> Bool in
            
            switch response.statusCode {
            case 200:
                guard let model = try? JSONDecoder().decode(IsSellerModel.self, from: data) else {
                    print("isSeller Model ERROR")
                    return false
                }
                return model.isSeller
            default:
                return false
            }
        }
    }
}

