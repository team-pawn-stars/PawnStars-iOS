//
//  SignInVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var signInViewModel: SignInViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInViewModel = SignInViewModel()
        
        idTextField.rx.text
            .orEmpty
            .bind(to: self.signInViewModel.id)
            .disposed(by: disposeBag)
        
        idTextField.rx.text
            .orEmpty
            .bind(to: self.signInViewModel.pw)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: signInViewModel.login)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
