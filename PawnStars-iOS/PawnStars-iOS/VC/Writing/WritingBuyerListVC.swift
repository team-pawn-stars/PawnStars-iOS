//
//  WritingBuyerVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 24/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit

class WritingBuyerListVC: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class PawnListCell: UITableViewCell {
    @IBOutlet weak var pawnImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var locationDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}
