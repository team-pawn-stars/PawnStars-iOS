//
//  SelectCategoryVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 26/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import DLRadioButton
import RxSwift
import RxCocoa

class SelectCategoryVC: UIViewController  {
    @IBOutlet weak var categoryDigital: DLRadioButton!
    @IBOutlet weak var categoryFurniture: DLRadioButton!
    @IBOutlet weak var categoryWomenClothing: DLRadioButton!
    @IBOutlet weak var categoryWomenAccessories: DLRadioButton!
    @IBOutlet weak var categoryMenClothing: DLRadioButton!
    @IBOutlet weak var categoryMenAccessories: DLRadioButton!
    @IBOutlet weak var categoryJewelry: DLRadioButton!
    @IBOutlet weak var categoryEtc: DLRadioButton!
    @IBOutlet weak var sortLatest: DLRadioButton!
    @IBOutlet weak var sortPopularity: DLRadioButton!
    
    var viewModel: PawnListViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension SelectCategoryVC{
    func bindViewModel() {
        viewModel = PawnListViewModel()
        
        let input = PawnListViewModel.SecondInput(categoryDigital: categoryDigital.rx.tap.asSignal(),
                                                  categoryFurniture: categoryFurniture.rx.tap.asSignal(),
                                                  categoryWomenClothing: categoryWomenClothing.rx.tap.asSignal(),
                                                  categoryWomenAccessories: categoryWomenAccessories.rx.tap.asSignal(),
                                                  categoryMenClothing: categoryMenClothing.rx.tap.asSignal(),
                                                  categoryMenAccessories: categoryMenAccessories.rx.tap.asSignal(),
                                                  categoryJewelry: categoryJewelry.rx.tap.asSignal(),
                                                  categoryEtc: categoryEtc.rx.tap.asSignal(),
                                                  sortLatest: sortLatest.rx.tap.asSignal(),
                                                  sortPopularity: sortPopularity.rx.tap.asSignal())
        
        viewModel.secondTransform(input: input)
    }
}
