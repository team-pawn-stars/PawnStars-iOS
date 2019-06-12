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
    private var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        bindViewModel()
    }
    
}

extension PawnDetailVC {
    func bindViewModel() {
        viewModel = PawnDetailViewModel()
        
        let input = PawnDetailViewModel.Input(postId: id,
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
        
        output.history
            .drive(historyTableView.rx.items(cellIdentifier: "historyCell", cellType: PawnHistoryCell.self)){ _, model, cell in
                cell.historyContent.text = model.content
                cell.historyDate.text = model.date
            }
            .disposed(by: disposeBag)
        
        output.price
            .drive(pawnPrice.rx.text)
            .disposed(by: disposeBag)
        
        output.photos
            .drive(onNext: { [weak self] urls in
                guard let `self` = self else { return }
                for i in urls.indices {
                    let vc = UIStoryboard(name: "PawnList", bundle: nil).instantiateViewController(withIdentifier: "imageContainerView") as! PawnImageContentVC
                    
                    vc.imageUrl.accept(urls[i])
                    self.viewControllers.append(vc)
                    
                    self.pageViewController
                        .setViewControllers([self.viewControllers[0]], direction: .forward, animated: false, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        output.isLiked
            .drive(onNext: { isLiked in
                if isLiked{
                    self.pawnLikeBtn.setBackgroundImage(UIImage(named: "fill_like"), for: .normal)
                } else {
                    self.pawnLikeBtn.setBackgroundImage(UIImage(named: "empty_like"), for: .normal)
                }
            })
        .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = self
            pageViewController.delegate = self
            if viewControllers.count > 0 {
                pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
            }
        }
    }
}

extension PawnDetailVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let curlIndex = viewControllers.index(of: viewController) else {return nil}
        
        let previousIndex = curlIndex - 1
        
        guard previousIndex >= 0 else{
            return viewControllers.last
        }
        
        guard viewControllers.count > previousIndex else{
            return nil
        }
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let curlIndex = viewControllers.index(of: viewController) else {return nil}
        
        let nextIndex = curlIndex + 1
        
        guard nextIndex < viewControllers.count else{
            return viewControllers.first
        }
        
        guard viewControllers.count > nextIndex else{
            return nil
        }
        
        return viewControllers[nextIndex]
    }
}

extension PawnDetailVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}



class PawnHistoryCell: UITableViewCell {
    @IBOutlet weak var historyDate: UILabel!
    @IBOutlet weak var historyContent: UILabel!
}
