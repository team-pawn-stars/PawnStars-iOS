//
//  FlexDetailContentVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 22/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class FlexDetailContentVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imageUrl = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
    var flexDetailContentViewModel: FlexDetailContentViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flexDetailContentViewModel = FlexDetailContentViewModel()
        
        let input = FlexDetailContentViewModel.Input(imageUrl: imageUrl)
        let output = flexDetailContentViewModel.transform(input: input)
        output.imageData
            .drive(imageView.rx.data)
            .disposed(by: disposeBag)
    }
}
