//
//  PawnListDetailViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 04/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PawnDetailViewModel {
    let disposeBag = DisposeBag()

    struct Input {
        let postId: BehaviorRelay<Int>
        let likeDidClicked: Signal<Void>
        let chatDidClicked: Signal<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let content: Driver<String>
        let category: Driver<String>
        let author: Driver<String>
        let region: Driver<String>
        let isLiked: Driver<Bool>
        let photos: Driver<[String]>
        let date: Driver<String>
        let totalLike: Driver<String>
        let history: Driver<[PawnHistoryModel]>
        let price: Driver<String>
    }
    
    func transform(input: PawnDetailViewModel.Input) -> PawnDetailViewModel.Output {
        let api = Api()
        
        let title = BehaviorRelay<String>(value: "")
        let content = BehaviorRelay<String>(value: "")
        let category = BehaviorRelay<String>(value: "")
        let author = BehaviorRelay<String>(value: "")
        let region = BehaviorRelay<String>(value: "")
        let isLiked = BehaviorRelay<Bool>(value: false)
        let photos = BehaviorRelay<[String]>(value: [])
        let date = BehaviorRelay<String>(value: "")
        let totalLike = BehaviorRelay<String>(value: "")
        let history = BehaviorRelay<[PawnHistoryModel]>(value: [])
        let price = BehaviorRelay<String>(value: "")
        
        
        input.postId.asObservable()
            .flatMapLatest { api.PawnDetail(postId: $0) }
            .subscribe(onNext: { model in
                title.accept(model?.title ?? "")
                content.accept(model?.content ?? "")
                category.accept(model?.category ?? "")
                author.accept(model?.author ?? "")
                region.accept(model?.region ?? "")
                isLiked.accept(model?.isLiked ?? false)
                photos.accept(model?.photos ?? [])
                date.accept(model?.date ?? "")
                totalLike.accept(model?.totalLike ?? "")
                history.accept(model?.histories ?? [])
                price.accept(model?.price ?? "")
            })
        .disposed(by: disposeBag)
        
        input.likeDidClicked.asObservable()
            .withLatestFrom(input.postId)
            .flatMapLatest { api.PawnLike(postId: $0) }
            .map { return $0 }
            .bind(to: isLiked)
        .disposed(by: disposeBag)
        
        return Output(title: title.asDriver(),
                      content: content.asDriver(),
                      category: category.asDriver(),
                      author: author.asDriver(),
                      region: region.asDriver(),
                      isLiked: isLiked.asDriver(),
                      photos: photos.asDriver(),
                      date: date.asDriver(),
                      totalLike: totalLike.asDriver(),
                      history: history.asDriver(),
                      price: price.asDriver())
    }
    
}
