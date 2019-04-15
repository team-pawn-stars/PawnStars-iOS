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
        
        let input = SignInViewModel.Input(username: idTextField.rx.text.orEmpty.asDriver(), password: pwTextField.rx.text.orEmpty.asDriver(), clickLogin: loginButton.rx.tap.asSignal())

        
        let output = signInViewModel.transform(input: input)
        
        output.result
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                
                if $0 == SignInResult.success {
                    
                } else if $0 == SignInResult.failure {
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
