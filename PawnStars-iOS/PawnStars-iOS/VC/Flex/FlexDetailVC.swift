//
//  FlexDetailVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 19/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FlexDetailVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var writeCommentButton: UIButton!
    
    var flexDetailViewModel: FlexDetailViewModel!
    let disposeBag = DisposeBag()
    let postId = BehaviorRelay<Int>(value: 0)
    private var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flexDetailViewModel = FlexDetailViewModel()
        
        let input = FlexDetailViewModel.Input(postId: postId, clickLike: likeButton.rx.tap.asSignal(), writeComment: writeCommentButton.rx.tap.asSignal(), comment: commentTextField.rx.text.orEmpty.asDriver())
        
        let output = flexDetailViewModel.transform(input: input)
        
        output.title.drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.author.drive(authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date.drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.likeNum.drive(likeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content.drive(contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.price.drive(priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.comment.drive(commentTableView.rx.items(cellIdentifier: "commentCell", cellType: CommentCell.self)) { _ , data, cell in
            cell.configure(model: data)
        }.disposed(by: disposeBag)
        
        output.imageUrls.asObservable().subscribe { [weak self] urls in
            guard let strongSelf = self else {return}
            if let urls = urls.element {
                for i in urls.indices {
                    let vc = UIStoryboard(name: "Flex", bundle: nil).instantiateViewController(withIdentifier: "flexDetailContent") as! FlexDetailContentVC
                    vc.imageUrl.accept(urls[i])
                    strongSelf.viewControllers.append(vc)
                    strongSelf.pageViewController.setViewControllers([strongSelf.viewControllers[0]], direction: .forward, animated: false, completion: nil)
                }
            }
        }.disposed(by: disposeBag)
        
        output.commentResult.asObservable().subscribe { [weak self] result in
            guard let strongSelf = self else {return}
            if let result = result.element {
                if !result {
                    strongSelf.showAlert(self: strongSelf, title: "오류", message: "", handler: nil, actionTitle: "확인")
                }
            }
        }.disposed(by: disposeBag)
        
        output.initComment
            .drive(commentTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func vcInstance() -> UIViewController {
        return UIStoryboard(name: "Flex", bundle: nil).instantiateViewController(withIdentifier: "flexDetailContent")
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


extension FlexDetailVC: UIPageViewControllerDataSource {
    
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

extension FlexDetailVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class CommentCell: UITableViewCell {
    @IBOutlet weak var mentionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    func configure(model: Comment) {
        
        model.mention.asDriver()
            .drive(mentionLabel.rx.text)
            .disposed(by: disposeBag)
        
        model.comment.asDriver()
            .drive(commentLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
