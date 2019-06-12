//
//  Base.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIViewController{
    // static method or property
    
    func showAlert(self vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil, actionTitle: String? = nil) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    if let actionTitle = actionTitle {
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler))
    }
    vc.present(alert, animated: true, completion: nil)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showToast(msg: String, fun: (() -> Void)? = nil){
        let toast = UILabel(frame: CGRect(x: 32, y: 450, width: view.frame.size.width - 64, height: 42))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toast.textColor = UIColor.white
        toast.text = msg
        toast.textAlignment = .center
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true
        toast.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth]
        view.addSubview(toast)
        UIView.animate(withDuration: 1, delay: 0.8, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: { _ in
            toast.removeFromSuperview()
            fun?()
        })
    }
    
}

enum FlexSortKey {
    case new,like
    
    func getKey() -> String {
        switch self {
        case .new: return "new"
        case .like: return "like"
        }
    }
}
