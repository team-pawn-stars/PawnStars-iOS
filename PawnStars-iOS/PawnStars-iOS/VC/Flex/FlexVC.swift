//
//  FlexVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class FlexVC : UIViewController {
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    var flexViewModel: FlexViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        flexViewModel = FlexViewModel()
        
        let input = FlexViewModel.Input(selectIndex: sortSegmentControl.rx.selectedSegmentIndex.asDriver(), nextPage: nextButton.rx.tap.asSignal())
        
        let output = flexViewModel.transform(input: input)
        
        output.flexList.drive(listTableView.rx.items(cellIdentifier: "flexCell", cellType: FlexCell.self)) { _ , data, cell in
            cell.flexNumLabel.text = "\(data.like)"
            cell.titleLabel.text = data.title
            cell.authorLabel.text = data.author
        }.disposed(by: disposeBag)
        
    }
}

class FlexCell: UITableViewCell {
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var flexNumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
}
