//
//  Shape.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    
    var valid: AnyObserver<Bool> {
        return Binder(base, binding: { (label: UILabel, valid: Bool) in
            label.textColor = (valid ? UIColor(red: 138/255, green: 000/255, blue: 254/255, alpha: 1.0) : UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0))
        }).asObserver()
    }
}
