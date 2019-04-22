//
//  Connector.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 17/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

protocol ConnectorType {
    func get(path: String, params: Parameters?, header : Header) -> Observable<(HTTPURLResponse,Data)>
    func post(path: String, params: Parameters?, header : Header) -> Observable<(HTTPURLResponse,Data)>
}

class Connector : ConnectorType {
    private let baseUrl = "http://whale.istruly.sexy:3214/"

    func get(path: String, params: Parameters?, header: Header) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.get,
                           baseUrl + path,
                           parameters: params,
                           encoding: URLEncoding.queryString,
                           headers: header.getHeader())
    }
    
    func post(path: String, params: Parameters?, header: Header) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.post,
                           baseUrl + path,
                           parameters: params,
                           encoding: JSONEncoding.default,
                           headers: header.getHeader())
    }
    
}

enum Header {
    case Authorization,Empty
    func getHeader() -> [String : String]? {
        switch self {
        case .Authorization:
            return ["Authorization" : UserDefaults.standard.value(forKey: "Token") as? String ?? "",
                    "Content-Type" : "application/json"]
        case .Empty :
            return ["Content-Type" : "application/json"]
        }
    }
}

enum StatusCode {
    case success, failure
}



