//
//  WritingVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class WritingVC : UIViewController {
    @IBOutlet weak var containerView: UIView!
    var writingViewModel: WritingViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false

        
        writingViewModel = WritingViewModel()
        
        let input = WritingViewModel.Input()
        let output = writingViewModel.transform(input: input)
        
        output.role.asObservable().subscribe { [weak self] role in
            guard let strongSelf = self else {return}
            if let role = role.element {
                switch role {
                case "SELLER":
                    let vc = UIStoryboard(name: "Writing", bundle: nil).instantiateViewController(withIdentifier: "writingSeller")
                    strongSelf.containerView.addSubview(vc.view)
                case "BUYER":
                    let vc = UIStoryboard(name: "Writing", bundle: nil).instantiateViewController(withIdentifier: "writingBuyer")
                    strongSelf.containerView.addSubview(vc.view)
                default: print("ERROR")
                }
            }
        }.disposed(by: disposeBag)
    }
}
