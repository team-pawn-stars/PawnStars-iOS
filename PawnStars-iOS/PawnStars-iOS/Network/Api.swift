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
    func statusCode(code : Int) -> StatusCode
}

protocol PawnBuyer {
    func getPawnList() -> Observable<(StatusCode, [PawnListModel]?)>
}

protocol ApiProvider : Account, PawnBuyer { }

class Api : ApiProvider {
    private let connector = Connector()
    
    func statusCode(code: Int) -> StatusCode {
        switch code {
        case 200,201: return StatusCode.success
        default: return StatusCode.failure
        }
    }

    
    func getPawnList() -> Observable<(StatusCode, [PawnListModel]?)> {
        return connector.get(path: PawnBuyerAPI.pawn.getPath(),
                             params: nil,
                             header: Header.Empty)
            .map { res,data -> (StatusCode, [PawnListModel]?) in
                guard let response = try? JSONDecoder().decode(PawnListResponse.self, from: data) else {
                    return (StatusCode.failure, nil)
                }
                return (self.statusCode(code: res.statusCode), response.result)
        }
    }
}
