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
    func flexDetail(postId: Int) -> Observable<FlexDetailModel?>
    func writeComment(flexPost: Int, content: String) -> Observable<Bool>
}

protocol WritingProvider {
    func writePawn(price: String, category: String, region: String, title: String, content: String) -> Observable<Int?>
    func writeImage(pawnPost: Int, photo: Data) -> Observable<Bool>
    func writeHistory(pawnPost: Int, histories: [History]) -> Observable<Bool>
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
}

class WritingApi: WritingProvider {
    
    private let connector = Connector()
    func writePawn(price: String, category: String, region: String, title: String, content: String) -> Observable<Int?> {
        return connector.post(path: WritingAPI.writePawn.getPath(),
                              params: ["price": Int(price) ?? 0, "category": category, "region":region,"title":title,"content":content],
                              header: .Authorization).map { (response, data) -> Int? in
                                switch response.statusCode {
                                case 201:
                                    guard let model = try? JSONDecoder().decode(WritingSellerModel.self, from: data) else {
                                        return (-1)
                                    }
                                    return model.postId
                                default: return -1
                                }
        }
    }
    
    func writeImage(pawnPost: Int, photo: Data) -> Observable<Bool> {
        return connector.post(path: WritingAPI.writePawnImage.getPath(),
                              params: ["pawn_post": pawnPost, "photo": photo],
                              header: .Authorization).map { (response,_) -> Bool in
                                switch response.statusCode {
                                case 201:
                                    return true
                                default: return false
                                }
        }
    }
    
    func writeHistory(pawnPost: Int, histories: [History]) -> Observable<Bool> {
        
        let token = UserDefaults.standard.value(forKey: "Token") as? String ?? ""
        let result = BehaviorRelay<Bool>(value: false)
        let model = WritingSellerHistoryModel(pawnPost: pawnPost, histories: histories)
        let jsonData = try? JSONEncoder().encode(model)
        
        let url = URL(string: connector.baseUrl + WritingAPI.writePawnHistory.getPath())
        guard let strongUrl = url else {return result.asObservable()}
        var request = URLRequest(url: strongUrl)

        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in

                if response.response?.statusCode == 201 {
                    result.accept(true)
                } else {
                    result.accept(false)
                }
        }
        
        return result.asObservable()
    }
}
