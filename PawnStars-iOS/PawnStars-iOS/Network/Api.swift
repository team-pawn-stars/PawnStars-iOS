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

protocol Account {

}

protocol PawnBuyer {
    func PawnList(category: String, sort_key: String, region: String) -> Observable<(StatusCode, [PawnListModel])>
}

protocol ApiProvider : Account, PawnBuyer {
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
}
