//
//  PawnImageViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 11/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PawnImageViewModel: ViewModelType {
    struct Input {
        let imageUrl: Driver<String>
    }
    
    struct Output {
        let imageData: Driver<Data>
    }
    
    func transform(input: PawnImageViewModel.Input) -> PawnImageViewModel.Output {
        let imageData = input.imageUrl.asObservable()
            .flatMapLatest { url -> Observable<Data> in
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
