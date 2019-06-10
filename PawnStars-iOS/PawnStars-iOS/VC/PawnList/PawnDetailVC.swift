//
//  PawnDetailVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 14/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PawnDetailVC: UIViewController {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var pawnLocation: UILabel!
    @IBOutlet weak var totalLike: UILabel!
    @IBOutlet weak var pawnTitle: UILabel!
    @IBOutlet weak var pawnCategoryWithTime: UILabel!
    @IBOutlet weak var pawnPrice: UILabel!
    @IBOutlet weak var pawnLikeBtn: UIButton!
    @IBOutlet weak var pawnChatingBtn: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var pawnContent: UITextView!
    
    var id = BehaviorRelay<Int>(value: 0)
    var viewModel: PawnDetailViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        print("fdas\(id.value)")
        bindViewModel()
    }
}

extension PawnDetailVC {
    func bindViewModel() {
        viewModel = PawnDetailViewModel()
        
        let input = PawnDetailViewModel.Input(postId: id.asDriver(),
                                              likeDidClicked: pawnLikeBtn.rx.tap.asSignal(),
                                              chatDidClicked: pawnChatingBtn.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.author
            .drive(authorName.rx.text)
            .disposed(by: disposeBag)
        
        output.region
            .drive(pawnLocation.rx.text)
            .disposed(by: disposeBag)
        
        output.title
            .drive(pawnTitle.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .drive(pawnContent.rx.text)
            .disposed(by: disposeBag)
        
        output.category
            .drive(onNext: { [weak self] category in
                output.date.drive(onNext: { [weak self] date in
                    self?.pawnCategoryWithTime.text = "\(category), \(date)"
                }).disposed(by: self!.disposeBag)
            }).disposed(by: disposeBag)
        
        output.totalLike
        .drive(totalLike.rx.text)
        .disposed(by: disposeBag)
    }
}

class PawnHistoryCell: UITableViewCell {
    @IBOutlet weak var historyDate: UILabel!
    @IBOutlet weak var historyContent: UILabel!
}
