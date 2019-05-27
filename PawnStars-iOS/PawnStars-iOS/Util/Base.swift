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
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
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
