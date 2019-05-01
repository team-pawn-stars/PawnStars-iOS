//
//  SignUpViewModel.swift
//  PawnStars-iOS
//
//  Created by daeun on 10/04/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

enum SignUpResult {
    case success, fail, existId, empty, seller
}

class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    let api = Api()
    let buyerOrPawn = Variable<String>("")
    let username = Variable<String>("")
    let password = Variable<String>("")
    let phoneNumAndNickName = Variable<(String,String)>(("",""))
    
    struct Input {
        let clickBuyer: Signal<Void>
        let clickPawn: Signal<Void>
        let clickNext: Signal<Void>
        let id: Driver<String>
        let pw: Driver<String>
        let pwCheck: Driver<String>
    }
    
    struct Output {
        let buyerColor: Driver<Bool>
        let pawnColor: Driver<Bool>
        let isNextEnabled: Driver<Bool>
        let moveNextPage: Driver<Bool>
    }
    
    struct SecondInput {
        let phoneNum: Driver<String>
        let nickName: Driver<String>
        let clickCreate: Signal<Void>
    }
    
    struct SecondOutput {
        let isCreateEnabled: Driver<Bool>
        let createAccount: Driver<SignUpResult>
    }
    
    struct ThirdInput {
        let searchText: Driver<String>
        let search: Signal<Void>
        let complete: Signal<Void>
    }
    
    struct ThirdOutput {
        let lng: Driver<CLLocationDegrees?>
        let lat: Driver<CLLocationDegrees?>
        let result: Driver<SignUpResult>
    }
    
    func transform(input: Input) -> Output {
        
        let clickBuyer = input.clickBuyer.asObservable().map{"BUYER"}
        let clickPawn = input.clickPawn.asObservable().map{"PAWN"}
        
        let buyerAndPawn = Observable.of(clickBuyer,clickPawn).merge()
        
        buyerAndPawn.subscribe(onNext: {[weak self] in self?.buyerOrPawn.value = $0})
            .disposed(by: disposeBag)
        
        input.id.asObservable().subscribe(onNext: { [weak self] in self?.username.value = $0 })
            .disposed(by: disposeBag)
        
        input.pw.asObservable().subscribe(onNext: { [weak self] in self?.password.value = $0})
            .disposed(by: disposeBag)
        
        let buyerColor = buyerAndPawn.map{ role in
            if role == "BUYER" { return true }
            else { return false }
            }.asDriver(onErrorJustReturn: false)
        
        let pawnColor = buyerAndPawn.map{ role in
            if role == "PAWN" { return true }
            else { return false }
            }.asDriver(onErrorJustReturn: false)
        
        let pwValid = Driver.combineLatest(input.pw, input.pwCheck) {$0 == $1 && !$0.isEmpty && !$1.isEmpty}
        let idPwEmptyCheck = Driver.combineLatest(input.id, input.pw) {!$0.isEmpty && !$1.isEmpty }
        let isNextEnabled = Driver.combineLatest(pwValid, idPwEmptyCheck) {$0 && $1}
        
        let moveNextPage = input.clickNext
            .map{ return true }
            .asDriver(onErrorJustReturn: false)
        
        return Output(buyerColor: buyerColor, pawnColor: pawnColor, isNextEnabled: isNextEnabled, moveNextPage: moveNextPage)
    }
    
    func secondTransform(input: SecondInput) -> SecondOutput {
        
        let phoneNumNickNameCheck = Driver.combineLatest(input.phoneNum, input.nickName) { (!$0.isEmpty && !$1.isEmpty) }
        let isCreateEnabled = Driver.combineLatest(phoneNumNickNameCheck, buyerOrPawn.asDriver()) {$0 && (!$1.isEmpty)}
        
        let phoneNumAndNickName = Driver.combineLatest(input.phoneNum, input.nickName) { ($0,$1) }
        let createAccount = input.clickCreate
            .asObservable()
            .withLatestFrom(phoneNumAndNickName)
            .flatMapLatest{ [weak self] pair  -> Driver<SignUpResult> in
                let (phoneNum, nickName) = pair
                
                if self?.buyerOrPawn.value == "BUYER" {
                    return self?.api.signUpBuyer(username: self?.username.value ?? "", password: self?.password.value ?? "", phoneNum: phoneNum, nickName: nickName).asDriver(onErrorJustReturn: SignUpResult.empty) ?? Driver.just(SignUpResult.empty)
                } else if self?.buyerOrPawn.value == "PAWN" {
                    self?.phoneNumAndNickName.value = (phoneNum,nickName)
                    return Driver.just(SignUpResult.seller)
                } else {return Driver.just(SignUpResult.empty)}
        }
        
        return SecondOutput(isCreateEnabled: isCreateEnabled, createAccount: createAccount.asDriver(onErrorJustReturn: SignUpResult.empty))
    }
    
    func thirdTransform(input: ThirdInput) -> ThirdOutput {
        let searchRequest = MKLocalSearch.Request()
        let searchText = Variable<String>("")
        let lat = Variable<CLLocationDegrees?>(CLLocationDegrees(exactly: 0))
        let lng = Variable<CLLocationDegrees?>(CLLocationDegrees(exactly: 0))
        
        input.searchText.asObservable().subscribe { searchText.value = $0.element ?? "" }.disposed(by: disposeBag)
        
        input.search.asObservable().subscribe { _ in
            searchRequest.naturalLanguageQuery = searchText.value
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (response, error) in
                if response == nil {
                    print("ERROR")
                } else {
                    lat.value = response?.boundingRegion.center.latitude
                    lng.value = response?.boundingRegion.center.longitude
                }
            }
        }.disposed(by: disposeBag)
        
        let latAndlng = Observable.combineLatest(lat.asObservable(), lng.asObservable()) {($0,$1)}
        
        let result = input.complete.asObservable().withLatestFrom(latAndlng).flatMapLatest { [weak self] pair -> Driver<SignUpResult> in
            let (lat, lng) = pair
            
            let (phoneNum, nickName) = self?.phoneNumAndNickName.value ?? ("","")
            
            if let lat = lat, let lng = lng {
                return self?.api.signUpSeller(username: self?.username.value ?? "", password: self?.password.value ?? "", phoneNum: phoneNum, nickName: nickName, lng: Float(lng), lat: Float(lat)).asDriver(onErrorJustReturn: SignUpResult.empty) ?? Driver.of(SignUpResult.empty)
            } else {
                return Driver.of(SignUpResult.empty)
            }

        }
        
        return ThirdOutput(lng: lng.asDriver(), lat: lat.asDriver(),result: result.asDriver(onErrorJustReturn: SignUpResult.empty))
    }
    
}
