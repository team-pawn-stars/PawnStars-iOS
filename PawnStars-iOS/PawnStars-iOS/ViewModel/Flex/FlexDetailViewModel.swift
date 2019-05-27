//
//  FlexDetailViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 19/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FlexDetailViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    let api = Api()
    
    struct Input {
        let postId: BehaviorRelay<Int>
        let clickLike: Signal<Void>
        let writeComment: Signal<Void>
        let comment: Driver<String>
    }
    
    struct Output {
        let title: Driver<String>
        let author: Driver<String>
        let date: Driver<String>
        let isLike: Driver<Bool>
        let likeNum: Driver<String>
        let content: Driver<String>
        let imageUrls: Driver<[String]>
        let comment: Driver<[Comment]>
        let price: Driver<String>
        let commentResult: Driver<Bool>
        let initComment: Driver<String>
        let likeResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let title = BehaviorRelay<String>(value: "")
        let author = BehaviorRelay<String>(value: "")
        let date = BehaviorRelay<String>(value: "")
        let isLike = BehaviorRelay<Bool>(value: false)
        let likeNum = BehaviorRelay<String>(value: "")
        let content = BehaviorRelay<String>(value: "")
        let imageUrls = BehaviorRelay<[String]>(value: [])
        let comment = BehaviorRelay<[Comment]>(value: [])
        let price = BehaviorRelay<String>(value: "")
        let initComment = BehaviorRelay<String>(value: "")
        let commentResult = PublishRelay<Bool>()
        let likeResult = PublishRelay<Bool>()
        
        input.postId.asObservable().subscribe { [weak self] postId in
            guard let strongSelf = self else {return}
            if let postId = postId.element {
                strongSelf.api.flexDetail(postId: postId).subscribe { model in
                    if let model = model.element {
                        if let model = model {
                            title.accept(model.title)
                            author.accept(model.author)
                            let index = model.date.index(model.date.startIndex, offsetBy: 10)
                            date.accept(model.date.substring(to: index))
                            isLike.accept(model.liked)
                            likeNum.accept(model.like)
                            content.accept(model.content)
                            imageUrls.accept(model.photos)
                            price.accept(model.price)
                            var comments: [Comment] = []
                            for i in model.comments.indices {
                                let comment = model.comments[i].content
                                let arr = comment.components(separatedBy: ["@","[","]","(",")"])
                                if arr.count >= 2 {
                                    comments.append(Comment(mention: arr[2], comment: arr[4]))
                                } else {
                                    comments.append(Comment(comment: arr[0]))
                                }
                            }
                            comment.accept(comments)
                        }
                    }
                    }.disposed(by: strongSelf.disposeBag)
            }
            
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(input.writeComment.asObservable(), input.comment.asObservable()).subscribe { [weak self] commentString in
            guard let strongSelf = self else {return}
            if let (_, commentString) = commentString.element {
                strongSelf.api.writeComment(flexPost: input.postId.value, content: commentString).subscribe { result in
                    if let result = result.element {
                        commentResult.accept(result)
                        if result {
                            initComment.accept("")
                            strongSelf.api.flexDetail(postId: input.postId.value).subscribe { model in
                                if let model = model.element {
                                    if let model = model {
                                        var comments: [Comment] = []
                                        for i in model.comments.indices {
                                            let comment = model.comments[i].content
                                            let arr = comment.components(separatedBy: ["@","[","]","(",")"])
                                            if arr.count >= 2 {
                                                comments.append(Comment(mention: arr[2], comment: arr[4]))
                                            } else {
                                                comments.append(Comment(comment: arr[0]))
                                            }
                                        }
                                        comment.accept(comments)
                                    }
                                }
                                }.disposed(by: strongSelf.disposeBag)
                        }
                    }
                    }.disposed(by: strongSelf.disposeBag)
            }
            }.disposed(by: disposeBag)
        
        input.clickLike.asObservable().subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.api.flexLike(postId: input.postId.value).subscribe { result in
                if let result = result.element {
                    likeResult.accept(result)
                    if result {
                        strongSelf.api.flexDetail(postId: input.postId.value).subscribe { model in
                            if let model = model.element {
                                if let model = model {
                                    likeNum.accept(model.like)
                                    isLike.accept(model.liked)
                                }
                            }
                        }.disposed(by: strongSelf.disposeBag)
                    }
                }
            }.disposed(by: strongSelf.disposeBag)
        }.disposed(by: disposeBag)
        
        return Output(title: title.asDriver(),
                      author: author.asDriver(),
                      date: date.asDriver(),
                      isLike: isLike.asDriver(),
                      likeNum: likeNum.asDriver(),
                      content: content.asDriver(),
                      imageUrls: imageUrls.asDriver(),
                      comment: comment.asDriver(),
                      price: price.asDriver(),
                      commentResult: commentResult.asDriver(onErrorJustReturn: false),
                      initComment: initComment.asDriver(),
                      likeResult: likeResult.asDriver(onErrorJustReturn: false))
    }
}

class Comment {
    let mention = BehaviorRelay<String>(value: "")
    let comment = BehaviorRelay<String>(value: "")
    
    init(mention: String, comment: String) {
        self.mention.accept(mention)
        self.comment.accept(comment)
    }
    
    init(comment: String) {
        self.comment.accept(comment)
    }
}
