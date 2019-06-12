//
//  PawnImageContentVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 11/06/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PawnImageContentVC: UIViewController {
    @IBOutlet weak var imageContainer: UIImageView!
    var imageUrl = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
    var pawnImageViewModel: PawnImageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pawnImageViewModel = PawnImageViewModel()
        
        let input = PawnImageViewModel.Input(imageUrl: imageUrl.asDriver())
        let output = pawnImageViewModel.transform(input: input)
        
        output.imageData
            .drive(imageContainer.rx.data)
            .disposed(by: disposeBag)
    }
}
