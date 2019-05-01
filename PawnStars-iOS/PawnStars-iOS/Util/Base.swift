//
//  Base.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAlert(self vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil, actionTitle: String? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if let actionTitle = actionTitle {
            alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler))
        }
        vc.present(alert, animated: true, completion: nil)
    }
}

