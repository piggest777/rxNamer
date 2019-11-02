//
//  submitNameVC.swift
//  rxNamer
//
//  Created by Denis Rakitin on 2019-10-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class SubmitNameVC: UIViewController {
    @IBOutlet weak var enterYourNameLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var namesListLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addNameBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    var namesArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
        bindAddNameBtn()
        namesArray.asObservable().subscribe(onNext: { names in
            self.namesListLbl.text = names.joined(separator: ", ")
            
            }).disposed(by: disposeBag)
    }

    @IBAction func submitBtnPressed(_ sender: Any) {
    }
    

    
    func bindTextField() {
        nameTxtField.rx.text
        .map {
           
            if $0 == "" {
                return "Type your name bellow"
            } else {
                 return "Hello, \($0!)"
            }
        }
        .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
        .bind(to: enterYourNameLbl.rx.text)
        .disposed(by: disposeBag)
    }
    
    func bindSubmitButton() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameTxtField.text != "" {
                self.namesArray.accept(self.namesArray.value + [self.nameTxtField!.text!])
                self.namesListLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameTxtField.rx.text.onNext("")
                self.enterYourNameLbl.rx.text.onNext("Type your name bellow")
            }
            }).disposed(by: disposeBag)
    }
    
    func bindAddNameBtn () {
        addNameBtn.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                guard let addNameVC = self.storyboard?.instantiateViewController(identifier: "addNameVC") as? AddNameVC else {
                    print("Could not create AddNameVC")
                    return
                }
                addNameVC.nameSubject.subscribe(onNext: { name in
                    self.namesArray.accept(self.namesArray.value + [name])
                    addNameVC.dismiss(animated: true, completion: nil)
                }).disposed(by: self.disposeBag)
                self.present(addNameVC, animated: true, completion: nil)
            })
    }
}

