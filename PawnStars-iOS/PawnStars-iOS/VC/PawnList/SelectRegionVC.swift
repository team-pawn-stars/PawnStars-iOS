//
//  SelectRegionVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 14/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SelectRegionVC: UIViewController {
    @IBOutlet weak var regionPickerView: UIPickerView!
    
    var viewModel = PawnListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension SelectRegionVC {
    func bindViewModel(){
        Observable
            .just(["서울","광주","대전","대구","부산","울산","인천","강원","경기","경남","전북","전남","제주","충북","충남"])
            .bind(to: regionPickerView.rx.itemTitles) { _, element in
                return "\(element)"
            }.disposed(by: disposeBag)
        
        let input = PawnListViewModel.ThirdInput(region: regionPickerView.rx.modelSelected(String.self).asDriver())
        
        viewModel.thirdTransform(input: input)
    }
}
