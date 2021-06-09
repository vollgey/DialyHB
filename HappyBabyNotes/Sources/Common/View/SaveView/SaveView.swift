//
//  SaveView.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 SaveButtonが押されたときのAlertView
 ***/

import UIKit

class SaveView: UIView {

    // OKが押されたときの処理
    @IBAction func okAction(_ sender: UIButton) {

        let printableCalendar = PrintableCalendar()
        printableCalendar.loadData()
        printableCalendar.renderHTML()

        self.removeFromSuperview()
    }

    // Cancelが押されたときの処理
    @IBAction func cancelAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
