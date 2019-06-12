//
//  WritingSellerVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 24/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class WritingSellerVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var addHistoryButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var completeButton: UIButton!
    
    var writingSellerViewModel: WritingSellerViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writingSellerViewModel = WritingSellerViewModel()
        
        let input = WritingSellerViewModel.Input(title: titleTextField.rx.text.orEmpty.asDriver(),
                                                 price: priceTextField.rx.text.orEmpty.asDriver(),
                                                 category: categoryPickerView.rx.modelSelected(String.self).asDriver(),
                                                 region: regionPickerView.rx.modelSelected(String.self).asDriver(),
                                                 content: contentTextView.rx.text.orEmpty.asDriver(),
                                                 clickComplete: completeButton.rx.tap.asSignal())
        
        let output = writingSellerViewModel.transform(input: input)
        
        output.category.drive(categoryPickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }
        
        output.region.drive(regionPickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }
        
        output.images.drive(photoCollectionView.rx.items(cellIdentifier: "photoCell", cellType: WritingSellerImageCell.self)) { _, data, cell in
            cell.configure(data: data)
        }.disposed(by: disposeBag)
        
        output.histories.drive(historyTableView.rx.items(cellIdentifier: "historyCell", cellType: WritingHistoryCell.self)) { _, data, cell in
            cell.configure(model: data)
        }.disposed(by: disposeBag)
        
        output.title.drive(titleTextField.rx.text)
        output.price.drive(priceTextField.rx.text)
        output.content.drive(contentTextView.rx.text)
        
        output.result.asObservable().subscribe { event in
            if let result = event.element {
                if result == -1 {
                    print("ERROR")
                }
            }
        }
        
        addHistoryButton.rx.tap.subscribe { _ in
            let complete = PublishRelay<Void>()
            let alert = UIAlertController(title: "alert", message: "textField", preferredStyle: .alert)
            let ok = UIAlertAction(title: "추가", style: .default) { (ok) in
                complete.accept(())
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            alert.addTextField { textField in
                textField.placeholder = "날짜 ex)2019-06-05"
            }
            alert.addTextField { textField in
                textField.placeholder = "내용"
            }
            self.present(alert, animated: true, completion: nil)
            
            let historyInput = WritingSellerViewModel.HistoryInput(historyTitle: alert.textFields![0].rx.text.orEmpty.asDriver(), historyDate: alert.textFields![1].rx.text.orEmpty.asDriver(), complete: complete)
            self.writingSellerViewModel.historyTransform(historyInput: historyInput)
        }
    }

}


class WritingHistoryCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func configure(model: History) {
        dateLabel.text = model.date
        contentLabel.text = model.content
    }
}

class WritingSellerImageCell: UICollectionViewCell {
    @IBOutlet weak var writingImageView: UIImageView!
    
    func configure(data: Data) {
        writingImageView.image = UIImage(data: data)
    }
}
