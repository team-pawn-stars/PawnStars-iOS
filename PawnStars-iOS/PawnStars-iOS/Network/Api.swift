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
    func getPawnList() -> Observable<(HTTPURLResponse?,[PawnListModel]?)>
}

protocol ApiProvider : Account, PawnBuyer { }

class Api : ApiProvider {
    private let connector = Connector()
    
    func getPawnList() -> Observable<(HTTPURLResponse?, [PawnListModel]?)> {
        return connector.get(path: PawnBuyerAPI.pawn.getPath(),
                             params: nil,
                             header: Header.Empty)
            .map { res,data in
                guard let response = try? JSONDecoder().decode(PawnListResponse.self, from: data) else {
                    return (nil,nil)
                }
            return (res, response.result)
        }
    }
    
}
