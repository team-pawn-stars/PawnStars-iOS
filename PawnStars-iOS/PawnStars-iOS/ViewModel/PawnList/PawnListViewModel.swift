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
    let userDefault = UserDefaults.standard
    
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
        let selectedDone: Signal<Int>
    }
    
    struct Dependencies {
        let api: Api
    }
    
    init() {
        connectModel = PawnListConnectModel()
    }
    
    private let dependencies = Dependencies(api: Api())
    
    func transform(input: PawnListViewModel.Input) -> PawnListViewModel.Output {
        let items = input.ready
            .asObservable()
            .flatMap { _ in
                self.dependencies.api.PawnList(category: self.userDefault.value(forKey: "category") as? String ?? "all",
                                               sort_key: self.userDefault.value(forKey: "orderBy") as? String ?? "new",
                                               region: self.userDefault.value(forKey: "region") as? String ?? "서울")
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
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: 0)
        
        
        return Output(items: items, selectedDone: selectedDone)
    }
    
    func secondTransform(input: SecondInput) {
//        self.connectModel.category.distinctUntilChanged()
//            .subscribe(onNext: { s in
//                print("transform2 \(s)")
//            })
//        .disposed(by: disposeBag)
//
//        self.connectModel.orderBy.distinctUntilChanged()
//            .subscribe(onNext: { s in
//                print("transform2\(s)")
//            })
//        .disposed(by: disposeBag)
        
        input.categoryDigital
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe {[weak self] _ in
                self?.userDefault.set("electronic", forKey: "category")
            }.disposed(by: disposeBag)
        
        input.categoryFurniture
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.userDefault.set("furniture", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryJewelry
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.userDefault.set("jewelry", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryMenClothing
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.userDefault.set("men_cloth", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryMenAccessories
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("men_goods", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryWomenClothing
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("women_cloth", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryWomenAccessories
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("women_goods", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.categoryEtc
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("etc", forKey: "category")
            }).disposed(by: disposeBag)
        
        input.sortLatest
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("new", forKey: "orderBy")
            }).disposed(by: disposeBag)
        
        input.sortPopularity
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.userDefault.set("like", forKey: "orderBy")
            }).disposed(by: disposeBag)
    }
    
    func thirdTransform(input: ThirdInput){
        input.region
            .asObservable()
            .subscribe(onNext: { [weak self] region in
                self?.userDefault.set(region[0], forKey: "region")
            }).disposed(by: disposeBag)
    }
    
    
}


