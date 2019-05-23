//
//  FlexDetailContentViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 23/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FlexDetailContentViewModel: ViewModelType {
    struct Input {
        let imageUrl: BehaviorRelay<String>
    }
    
    struct Output {
        let imageData: Driver<Data>
    }
    
    func transform(input: Input) -> Output {
        let imageData = input.imageUrl.flatMapLatest { url -> Observable<Data> in
            do {
                let url = URL(string: "http://whale.istruly.sexy:3214\(url)")
                let data = try Data(contentsOf: url!)
                return Observable.of(data)
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            return Observable.of(Data())
        }
        
        return Output(imageData: imageData.asDriver(onErrorJustReturn: Data()))
    }
}
