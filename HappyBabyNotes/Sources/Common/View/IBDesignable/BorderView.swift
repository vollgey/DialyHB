//
//  BorderView.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/03/20.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit

@IBDesignable
class BorderView: UIView {

    override func draw(_ rect: CGRect) {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }

}
