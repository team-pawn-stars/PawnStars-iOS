//
//  PawnListVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/03/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class PawnListVC : UIViewController {
    @IBOutlet weak var pawnlistTableView: dynamicTableView!
    var id = 0
    var pawnlistViewModel: PawnListViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pawnlistTableView.separatorStyle = .none
    }
}

extension PawnListVC {
    func bindViewModel(){
        pawnlistViewModel = PawnListViewModel()
        
        let input = PawnListViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                            cellSelected: pawnlistTableView.rx.itemSelected.asSignal())
       
        let output = pawnlistViewModel.transform(input: input)
        
        output.items
            .drive(pawnlistTableView.rx.items(cellIdentifier: "PawnListCell", cellType: PawnCell.self)) { _, model, cell in
                cell.selectionStyle = .none
                cell.pawnImage.kf.setImage(with: URL(string: model.photo ?? ""))
                cell.pawnTitle.text = model.title
                cell.pawnPrice.text = model.price
                cell.pawnTotalLike.text = "\(model.like)"
                cell.pawnContent.text = model.authorName
                cell.pawnLocationWithCreated.text = "\(model.region), \(model.date)"
        }.disposed(by: disposeBag)
        
        output.selectedDone
            .drive(onNext: { [weak self] id in
                guard let `self` = self else { return }
                print("fdas\(id)")
                self.id = id
                self.performSegue(withIdentifier: "toPawnDetail", sender: nil)
            }).disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPawnDetail" {
            let pawnDetailVC = segue.destination as! PawnDetailVC
            pawnDetailVC.id.accept(self.id)
        }
    }
}


class PawnCell : UITableViewCell{
    @IBOutlet weak var pawnImage: UIImageView!
    @IBOutlet weak var pawnTitle: UILabel!
    @IBOutlet weak var pawnContent: UILabel!
    @IBOutlet weak var pawnLocationWithCreated: UILabel!
    @IBOutlet weak var pawnPrice: UILabel!
    @IBOutlet weak var pawnTotalLike: UILabel!
}
