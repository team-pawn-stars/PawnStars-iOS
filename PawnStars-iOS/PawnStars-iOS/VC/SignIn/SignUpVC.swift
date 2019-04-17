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
        
        let input = SignUpViewModel.Input(clickBuyer: buyerButton.rx.tap.asSignal(), clickPawn: pawnButton.rx.tap.asSignal(), clickNext: firstContentVC.nextButton.rx.tap.asSignal())
        
        let output = signUpViewModel.transform(input: input)
        
        output.buyerColor.drive(buyerLabel.rx.valid)
            .disposed(by: disposeBag)
        
        output.pawnColor.drive(pawnLabel.rx.valid)
            .disposed(by: disposeBag)
        
        output.moveNextPage.asObservable().subscribe{ [weak self] isNext in
            guard let strongSelf = self else { return }
            if isNext.element == true {
                strongSelf.pageViewController.setViewControllers([strongSelf.viewControllers[1]], direction: .forward, animated: false, completion: nil)
            }
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = nil
            pageViewController.delegate = self
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
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
