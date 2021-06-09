//
//  DateTextField.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/03/20.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit
import SwiftDate

class DateTextField: UITextField {

    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()

    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: UITextField.textDidBeginEditingNotification, object: nil)
    }

    @objc func handle(notification: Notification) {
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.datePickerMode = .date

        self.inputView = datePicker
        addToolbar()
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }

    private func addToolbar() {
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44.0)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDone))
        toolbar.setItems([space, done], animated: true)
        self.inputAccessoryView = toolbar
    }

    @objc private func didDone() {
        //        let id = self.tag
        //        if let birthday = self.text?.toDate("yyyyMMdd")?.date {
        //            //            try! Baby.update(manNumber: id, birthday: birthday)
        //        }
        self.resignFirstResponder()
    }

    @objc private func handleDatePicker(sender: UIDatePicker) {
        self.text = sender.date.toFormat("yyyy年MM月dd日")
    }

}
