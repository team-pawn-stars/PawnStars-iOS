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
    
    private var pageViewController: UIPageViewController!
    
    let firstContentVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "signUpFirst") as! SignUpContentFirstVC
    
    let secondContentVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "signUpSecond") as! SignUpContentSecondVC
    
    private lazy var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        viewControllers.append(firstContentVC)
        viewControllers.append(secondContentVC)
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpViewModel = SignUpViewModel()
        
        let input = SignUpViewModel.Input(clickBuyer: buyerButton.rx.tap.asSignal(), clickPawn: pawnButton.rx.tap.asSignal(), clickNext: firstContentVC.nextButton.rx.tap.asSignal(), id: firstContentVC.idTextField.rx.text.orEmpty.asDriver(), pw: firstContentVC.pwTextField.rx.text.orEmpty.asDriver(), pwCheck: firstContentVC.pwCheckTextField.rx.text.orEmpty.asDriver())
        
        let output = signUpViewModel.transform(input: input)
        
        output.buyerColor.drive(buyerLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.pawnColor.drive(pawnLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.isNextEnabled.drive(firstContentVC.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.moveNextPage.asObservable().subscribe{ [weak self] isNext in
            guard let strongSelf = self else { return }
            if isNext.element == true {
                strongSelf.pageViewController.setViewControllers([strongSelf.viewControllers[1]], direction: .forward, animated: false, completion: nil)
                
                let secondInput = SignUpViewModel.SecondInput(phoneNum: strongSelf.secondContentVC.phoneNumTextField.rx.text.orEmpty.asDriver(), nickName: strongSelf.secondContentVC.nickNameTextField.rx.text.orEmpty.asDriver(), clickCreate: strongSelf.secondContentVC.createButton.rx.tap.asSignal())
                
                let secondOutput = strongSelf.signUpViewModel.secondTransform(input: secondInput)
                
                secondOutput.isCreateEnabled.drive(strongSelf.secondContentVC.createButton.rx.isEnabled)
                    .disposed(by: strongSelf.disposeBag)
                
                secondOutput.createAccount.asObservable().subscribe{ [weak self] result in
                    switch result.element! {
                    case SignUpResult.success : self?.navigationController?.popToRootViewController(animated: true)
                    case SignUpResult.existId : self?.showAlert(self: self!, title: "실패", message: "이미 있는 아이디", actionTitle: "확인")
                    case SignUpResult.fail : self?.showAlert(self: self!, title: "실패", message: "", actionTitle: "확인")
                    case SignUpResult.seller : self?.performSegue(withIdentifier: "selectLocation", sender: nil)
                    default: self?.showAlert(self: self!, title: "오류", message: "", actionTitle: "확인")
                    }
                    }.disposed(by: strongSelf.disposeBag)
                
            }
            }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = nil
            pageViewController.delegate = self
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
        
        if segue.identifier == "selectLocation" {
            if let vc = segue.destination as? SignUpLocationVC {
                vc.signUpViewModel = signUpViewModel
            }
        }
    }
}

extension SignUpVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
