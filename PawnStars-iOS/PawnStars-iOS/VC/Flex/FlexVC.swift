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
import Kingfisher

class FlexVC : UIViewController {
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    var flexViewModel: FlexViewModel!
    let disposeBag = DisposeBag()
    var postId = 0
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        
        flexViewModel = FlexViewModel()
        
        let input = FlexViewModel.Input(selectIndex: sortSegmentControl.rx.selectedSegmentIndex.asDriver(), nextPage: nextButton.rx.tap.asSignal(), selectPostId: listTableView.rx.itemSelected.asDriver())
        
        let output = flexViewModel.transform(input: input)
        
        output.flexList.drive(listTableView.rx.items(cellIdentifier: "flexCell", cellType: FlexCell.self)) { _ , data, cell in
            cell.configure(model: data)
            }.disposed(by: disposeBag)
        
        output.postId.subscribe {[weak self] postId in
            guard let strongSelf = self else {return}
            if let postId = postId.element {
                strongSelf.postId = postId
            }
        }.disposed(by: disposeBag)
        
        listTableView.rx.itemSelected.subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.performSegue(withIdentifier: "goFlexDetail", sender: nil)
            }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFlexDetail" {
            let vc = segue.destination as? FlexDetailVC
            vc?.postId.accept(postId)
        }
    }
}

class FlexCell: UITableViewCell {
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var flexNumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    func configure(model: FlexListModel) {
        
        if let imageUrl = model.photo {
            listImageView.kf.setImage(with: URL(string: imageUrl))
        }
        flexNumLabel.text = "\(model.like)"
        titleLabel.text = model.title
        authorLabel.text = model.author
        priceLabel.text = model.price
    }
}
