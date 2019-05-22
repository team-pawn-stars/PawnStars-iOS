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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = imageUrl.asObservable().flatMapLatest { url -> Observable<UIImage> in
            
            let url = URL(string: "http://whale.istruly.sexy:3214\(url)")
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                return Observable<UIImage>.of(image!)
                
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            return Observable<UIImage>.of(UIImage())
        }
        image.bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
}
