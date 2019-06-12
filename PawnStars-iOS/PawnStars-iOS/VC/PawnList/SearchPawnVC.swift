//
//  SearchPawnVC.swift
//  PawnStars-iOS
//
//  Created by 조우진 on 27/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchPawnVC: UIViewController {
    @IBOutlet weak var pawnSearchBar: UISearchBar!
    @IBOutlet weak var pawnSearchList: UITableView!
    
    var id = 0
    var viewModel: PawnSearchViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension SearchPawnVC {
    func bindViewModel(){
        viewModel = PawnSearchViewModel()
        
        let input = PawnSearchViewModel.Input(searchString: pawnSearchBar.rx.text,
                                              cellSelected: pawnSearchList.rx.itemSelected.asSignal())
        
        let output = viewModel.transform(input: input)
       
        output.searchList
            .drive(pawnSearchList.rx.items(cellIdentifier: "SearchPawnCell", cellType: PawnCell.self)) { _, model, cell in
                cell.selectionStyle = .none
                cell.pawnImage.kf.setImage(with: URL(string: model.photo ?? ""))
                cell.pawnTitle.text = model.title
                cell.pawnPrice.text = model.price
                cell.pawnTotalLike.text = "\(model.like)"
                cell.pawnContent.text = model.authorName
                cell.pawnLocationWithCreated.text = "\(model.region), \(model.date)"
            }.disposed(by: disposeBag)
        
        output.selectedDone.drive(onNext: { [weak self] id in
            guard let `self` = self else { return }
            self.id = id
            self.performSegue(withIdentifier: "goPawnDetail", sender: nil)
        })
        .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPawnDetail"{
            let pawnDetailVC = segue.destination as! PawnDetailVC
            pawnDetailVC.id.accept(self.id)
        }
    }
}
