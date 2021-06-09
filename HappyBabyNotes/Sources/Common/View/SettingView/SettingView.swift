//
//  SettingView.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit

class SettingView: UIView, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBAction func nameField(_ sender: Any) {
        nameField.text = "baby1"

    }
    @IBAction func birthField(_ sender: Any) {
        birthField.text = "2019年01月01日"
        let birthdatePicker = UIDatePicker()

        func textFieldDidBeginEditing(_ textField: UITextField) {
            birthdatePicker.datePickerMode = UIDatePicker.Mode.date
            birthdatePicker.timeZone = TimeZone.current
            birthdatePicker.locale = Locale.current
            textField.inputView = birthdatePicker
        }
        func birthdatePickerChanged(picker: UIDatePicker) {
            birthField.text = picker.date.toFormat("yyyy年MM月dd日")
        }

    }

    @IBAction func colorField(_ sender: Any) {
        colorField.text = "選択してください"
    }

}
