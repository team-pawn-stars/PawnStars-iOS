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
        
        output.result.drive(onNext: { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success:
                strongSelf.performSegue(withIdentifier: "goMain", sender: nil)
            case .failure:
                strongSelf.showAlert(self: strongSelf, title: "로그인 실패", message: "", actionTitle: "확인")
            default :
                strongSelf.showAlert(self: strongSelf, title: "오류", message: "", actionTitle: "확인")
            }
        }).disposed(by: disposeBag)
        
        output.token.drive(onNext: { token in
            guard let token = token else {return}
            UserDefaults.standard.set(token, forKey: "Token")
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
