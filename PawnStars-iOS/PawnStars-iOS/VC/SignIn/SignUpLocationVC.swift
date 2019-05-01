//
//  SignUpLocationVC.swift
//  PawnStars-iOS
//
//  Created by daeun on 01/05/2019.
//  Copyright © 2019 PawnStars. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

class SignUpLocationVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextButton: UIButton!
    var signUpViewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(clickSearch))
    }
    
    @objc func clickSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController,animated: true,completion: nil)
        
        let input = SignUpViewModel.ThirdInput(searchText: searchController.searchBar.rx.text.orEmpty.asDriver(), search: searchController.searchBar.rx.searchButtonClicked.asSignal(), complete: nextButton.rx.tap.asSignal())
        
        let output = signUpViewModel.thirdTransform(input: input)
        
        let latAndLng = Driver.combineLatest(output.lat,output.lng) {($0,$1)}
        
        latAndLng.asObservable().subscribe { [weak self] pair in
            guard let strongSelf = self else {return}
            
            let (lat, lng) = pair.element ?? (0,0)
            
            let annotaions = strongSelf.mapView.annotations
            strongSelf.mapView.removeAnnotations(annotaions)
            
            let annotaion = MKPointAnnotation()
            annotaion.title = searchController.searchBar.text
            annotaion.coordinate = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lng ?? 0)
            strongSelf.mapView.addAnnotation(annotaion)
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat ?? 0, lng ?? 0)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            strongSelf.mapView.setRegion(region, animated: true)
            
            }.disposed(by: disposeBag)
        
        output.result.asObservable().subscribe { [weak self] result in
            if let result = result.element {
                switch result {
                case SignUpResult.success : self?.navigationController?.popToRootViewController(animated: true)
                case SignUpResult.existId : self?.showAlert(self: self!, title: "실패", message: "이미 있는 아이디", actionTitle: "확인")
                case SignUpResult.fail : self?.showAlert(self: self!, title: "실패", message: "", actionTitle: "확인")
                default: self?.showAlert(self: self!, title: "오류", message: "", actionTitle: "확인")
                }
            }
        }.disposed(by: disposeBag)
    }
}

extension SignUpLocationVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
