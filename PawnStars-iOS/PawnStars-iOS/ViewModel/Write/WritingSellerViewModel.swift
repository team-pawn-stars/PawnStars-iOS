//
//  WritingSellerViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 24/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WritingSellerViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let histories = Variable<[History]>([])
    let images = Variable<[Data]>([])
    
    struct Input {
        let title: Driver<String>
        let price: Driver<String>
        let category: Driver<[String]>
        let region: Driver<[String]>
        let content: Driver<String>
        let clickComplete: Signal<Void>
    }
    
    struct ImageInput {
        let image: Driver<Data>
    }
    
    struct HistoryInput {
        let historyTitle: Driver<String>
        let historyDate: Driver<String>
        let complete: PublishRelay<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let price: Driver<String>
        let category: Driver<[String]>
        let region: Driver<[String]>
        let content: Driver<String>
        let result: Driver<Int?>
        let images: Driver<[Data]>
        let histories: Driver<[History]>
    }
    
    func transform(input: Input) -> Output {
        let api = WritingApi()
        let result = BehaviorRelay<Int?>(value: nil)
        let title = BehaviorRelay<String>(value: "")
        let price = BehaviorRelay<String>(value: "")
        let category = Driver<[String]>.of(["전체","디지털/가전","가구/인테리어","여성 의류","여성 잡화",
                                            "남성 의류","남성 잡화","귀금속","기타"])
        
        let categoryKorean = ["전체","디지털/가전","가구/인테리어","여성 의류","여성 잡화",
                             "남성 의류","남성 잡화","귀금속","기타"]
        let categoryEnglish = [ "all","electronic","furniture","women_cloth","women_goods",
                                "men_cloth", "men_goods","jewel","etc"]
        let region = Driver<[String]>.of(["서울","광주","대전","대구","부산",
                                          "울산","인천","강원","경기","경남",
                                          "전북","전남","제주","충북","충남"])
        let content = BehaviorRelay<String>(value: "")

        var categoryString: String = "all"
        
        input.category.asObservable().subscribe { event in
            if let array = event.element {
                let index = categoryKorean.index(of: array[0])
                categoryString = categoryEnglish[index ?? 0]
            }
        }
        
        var regionCategory = "서울"
        
        input.region.asObservable().subscribe { event in
            if let array = event.element {
                regionCategory = array[0]
            }
        }
        
        input.price.asObservable().subscribe { event in
            if let priceString = event.element {
                price.accept(priceString)
            }
        }
        
        input.title.asObservable().subscribe { event in
            if let titleString = event.element {
                title.accept(titleString)
            }
        }
        
        input.content.asObservable().subscribe { event in
            if let contentString = event.element {
                content.accept(contentString)
            }
        }
        
        input.clickComplete.asObservable().subscribe { _ in
            api.writePawn(price: price.value, category: categoryString, region: regionCategory, title: title.value, content: content.value).subscribe { event in
                if let resultInt = event.element {
                    result.accept(resultInt)
                }
                price.accept("")
                title.accept("")
                content.accept("")
            }
        }
        
        return Output(title: title.asDriver(), price: price.asDriver(), category: category, region: region, content: content.asDriver(), result: result.asDriver(), images: images.asDriver(), histories: histories.asDriver())
    }
    
    func imageTransform(imageInput: ImageInput) {
        imageInput.image.asObservable().subscribe { [weak self] image in
            guard let strongSelf = self else {return}
            if let image = image.element {
                strongSelf.images.value.append(image)
            }
            }.disposed(by: disposeBag)
    }
    
    func historyTransform(historyInput: HistoryInput) {
        
        historyInput.complete.asObservable().subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            let history = Observable.combineLatest(historyInput.historyTitle.asObservable(),
                                                   historyInput.historyDate.asObservable())
            history.asObservable().subscribe { [weak self] (value) in
                guard let strongSelf = self else {return}
                if let value = value.element {
                    let (content, date) = value
                    strongSelf.histories.value.append(History(date: date, content: content))
                }
                }.disposed(by: strongSelf.disposeBag)
        }.disposed(by: disposeBag)

    }
}
