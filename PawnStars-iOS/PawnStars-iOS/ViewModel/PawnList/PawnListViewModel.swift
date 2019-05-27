//
//  PawnListViewModel.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 08/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import RxSwift
import RxCocoa

class PawnListViewModel: ViewModelType {
    let connectModel: PawnListConnectModel!
    let disposeBag = DisposeBag()
    
    struct Input{
        let ready: Driver<Void>
        let cellSelected: Signal<IndexPath>
    }
    
    struct SecondInput {
        let categoryDigital: Signal<Void>
        let categoryFurniture: Signal<Void>
        let categoryWomenClothing: Signal<Void>
        let categoryWomenAccessories: Signal<Void>
        let categoryMenClothing: Signal<Void>
        let categoryMenAccessories: Signal<Void>
        let categoryJewelry: Signal<Void>
        let categoryEtc: Signal<Void>
        let sortLatest: Signal<Void>
        let sortPopularity: Signal<Void>
    }
    
    struct ThirdInput {
        let region: Driver<[String]>
    }
    
    struct Output {
        let items: Driver<[PawnListModel]>
        let selectedDone: Driver<Int>
    }
    
    struct Dependencies {
        let api: Api
    }
    
    init() {
        connectModel = PawnListConnectModel()
    }
    
    private let dependencies = Dependencies(api: Api())
    
    func transform(input: PawnListViewModel.Input) -> PawnListViewModel.Output {
        print("transform1 \(self.connectModel.category.value)")
        
        
        let items = input.ready
            .asObservable()
            .flatMap { _ in
                self.dependencies.api.PawnList(category: self.connectModel.category.value,
                                               sort_key: self.connectModel.orderBy.value,
                                               region: self.connectModel.region.value)
            }
            .map { statusCode, data -> [PawnListModel] in
                switch statusCode{
                case .success: return data
                case .failure: return []
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedDone = Observable.combineLatest(input.cellSelected.asObservable(), items.asObservable(),resultSelector: { (path, data) in
            return data[path.row]
        })
            .map { $0.postId }
            .asDriver(onErrorJustReturn: 0)
        
        
        
        return Output(items: items, selectedDone: selectedDone)
    }
    
    func secondTransform(input: SecondInput) {
        print("transform2 \(self.connectModel.category.value)")
        
        input.categoryDigital
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe {[weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("electronic")
            }.disposed(by: disposeBag)
        
        input.categoryFurniture
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("furniture")
            }).disposed(by: disposeBag)
        
        input.categoryJewelry
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("jewelry")
            }).disposed(by: disposeBag)
        
        input.categoryMenClothing
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("men_cloth")
            }).disposed(by: disposeBag)
        
        input.categoryMenAccessories
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("men_goods")
            }).disposed(by: disposeBag)
        
        input.categoryWomenClothing
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("women_cloth")
            }).disposed(by: disposeBag)
        
        input.categoryWomenAccessories
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("women_goods")
            }).disposed(by: disposeBag)
        
        input.categoryEtc
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("fdsa\(self!.connectModel.category.value)")
                
                self?.connectModel.category.accept("etc")
            }).disposed(by: disposeBag)
        
        input.sortLatest
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.orderBy.accept("new")
            }).disposed(by: disposeBag)
        
        input.sortPopularity
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.orderBy.accept("like")
            }).disposed(by: disposeBag)
    }
    
    func thirdTransform(input: ThirdInput){
        input.region
            .asObservable()
            .subscribe(onNext: { [weak self] region in
                self?.connectModel.region.accept(region[0])
            }).disposed(by: disposeBag)
    }
    
    
}


