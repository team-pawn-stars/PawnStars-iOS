//
//  SignInVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInViewModel = SignInViewModel()
        
        let input = SignInViewModel.Input(username: idTextField.rx.text.orEmpty.asDriver(), password: pwTextField.rx.text.orEmpty.asDriver(), clickLogin: loginButton.rx.tap.asSignal())

        
        let output = signInViewModel.transform(input: input)
        
        output.result.drive(onNext: { [weak self] result in

            switch result {
            case .success:
                self?.performSegue(withIdentifier: "goMain", sender: nil)
                
            case .failure:
                let alert = UIAlertController(title: "로그인 실패", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(UIAlertAction) -> Void in _ = self?.navigationController?.popToRootViewController(animated: true)}))
                self?.present(alert, animated: true, completion: nil)
                
            default :
                let alert = UIAlertController(title: "에러", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(UIAlertAction) -> Void in _ = self?.navigationController?.popToRootViewController(animated: true)}))
                self?.present(alert, animated: true, completion: nil)
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
