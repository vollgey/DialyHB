//
//  SelectBabyButton.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2019/10/31.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 SelectBabyButtonの情報を統括するファイル.
 ***/

import UIKit
import RxSwift
import RxCocoa

class SelectBabyButton: CollectionViewCell {
    @IBOutlet weak var babyButton: UIButton!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        babyButton.layer.borderWidth = 0.2
        babyButton.layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }

    func configure(flux: Flux) {
    }

}
