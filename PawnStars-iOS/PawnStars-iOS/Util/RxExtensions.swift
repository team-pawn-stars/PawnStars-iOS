//
//  RxExtensions.swift
//  PawnStars-iOS
//
//  Created by daeun on 23/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    
    var textColor: AnyObserver<Bool> {
        return Binder(base, binding: { (label: UILabel, valid: Bool) in
            label.textColor = (valid ? UIColor(red: 138/255, green: 000/255, blue: 254/255, alpha: 1.0) : UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0))
        }).asObserver()
    }
}

extension Reactive where Base: UIButton {
    var image: AnyObserver<Bool> {
        return Binder(base, binding: { (button: UIButton, valid: Bool) in
            button.setImage(valid ? UIImage(named: "flexIcon.png") : UIImage(named: "grayFlexIcon.png"), for: .normal)
        }).asObserver()
    }
}

extension Reactive where Base: UIImageView {
    var data: AnyObserver<Data> {
        return Binder(base, binding: { (imageView: UIImageView, data: Data) in
            imageView.image = UIImage(data: data)
        }).asObserver()
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
