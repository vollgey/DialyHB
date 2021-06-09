//
//  RoundView.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit

// AlertViewの角丸枠
@IBDesignable
class RoundView: UIView {

    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        layer.cornerRadius = 8.0
    }

}
