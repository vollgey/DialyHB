//
//  ColumnLabel.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit

// カラムのLabel
@IBDesignable
class ColumnLabel: UILabel {

    override func draw(_ rect: CGRect) {
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
    }

}
