//
//  ViewController.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit

class MainVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.viewControllers = [self]
        self.navigationItem.title = "P A W N   S T A R S"
    }
}

