//
//  BabyNameViewController.swift
//  HappyBabyNotes
//
//  Created by Au on 25/12/2019.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BabyNameViewController: UIViewController {

    let flux: Flux
    let babyID: Int

    @IBOutlet weak var babyTextField: UITextField!
    let disposeBag = DisposeBag()
    init(flux: Flux, babyID: Int) {
        self.flux = flux
        self.babyID = babyID
        super.init(nibName: "BabyNameViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        flux.settingsAction.clearSelectedBaby()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //枠の黒縁
        babyTextField.borderStyle = UITextField.BorderStyle.line
        //編集バツマーク
        babyTextField.clearButtonMode = UITextField.ViewMode.always

        self.babyTextField.text = self.flux.settingsStore.value.babies.filter { $0.id == self.babyID }.first?.name

        //名前の入力
        babyTextField.rx.text.orEmpty.subscribe(onNext: { [unowned self]name in
            self.flux.settingsAction.update(BabyID: self.babyID, name: name)
        }).disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }

}

/*
 // MARK: - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
