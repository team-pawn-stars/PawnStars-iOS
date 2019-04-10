//
//  SignUpVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    @IBOutlet weak var buyerButton: UIButton!
    @IBOutlet weak var pawnButton: UIButton!
    @IBOutlet weak var buyerLabel: UILabel!
    @IBOutlet weak var pawnLabel: UILabel!
    
    var signUpViewModel: SignUpViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpViewModel = SignUpViewModel()
        
        signUpViewModel.buyerColor
            .bind(to: buyerLabel.rx.valid)
            .disposed(by: disposeBag)
        
        signUpViewModel.pawnColor
            .bind(to: pawnLabel.rx.valid)
            .disposed(by: disposeBag)
        
        buyerButton.rx.tap
            .bind(to: self.signUpViewModel.clickBuyer)
            .disposed(by: disposeBag)
        
        pawnButton.rx.tap
            .bind(to: self.signUpViewModel.clickPawn)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
