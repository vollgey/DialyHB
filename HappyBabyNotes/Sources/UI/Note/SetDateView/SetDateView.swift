//
//  SetDateView.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 日付が押されたときのAlertView
 ***/

import UIKit
import SwiftDate

class SetDateView: UIView, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var textField: UITextField!
    var datePicker = UIDatePicker()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale.current
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }

    @objc func datePickerChanged(picker: UIDatePicker) {
        textField.text = picker.date.toString(.date(.long))
    }
    // OKが押されたときの処理
    @IBAction func okAction(_ sender: UIButton) {
        textField.endEditing(true)
        self.removeFromSuperview()
    }

    // Cancelが押されたときの処理
    @IBAction func cancelAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
