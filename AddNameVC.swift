//
//  AddNameVC.swift
//  rxNamer
//
//  Created by Denis Rakitin on 2019-10-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {

    @IBOutlet weak var newNameTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let disposeBag = DisposeBag()
    let nameSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        bindSubmitBtn()
    }
    
    func bindSubmitBtn() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.newNameTxtField.text != "" {
                self.nameSubject.onNext(self.newNameTxtField.text!)
            }
            
            }).disposed(by: disposeBag)
    }


}
