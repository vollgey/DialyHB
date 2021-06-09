//
//  MemoViewController.swift
//  HappyBabyNotes
//
//  Created by Au on 21/03/2020.
//

import UIKit

class MemoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!

    let flux: Flux
    let record: HourlyRecord

    init(flux: Flux, record: HourlyRecord) {
        self.flux = flux
        self.record = record
        super.init(nibName: MemoViewController.className, bundle: nil)
    }

    deinit {
        flux.noteAction.isEditable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func okButtonTapped(_ sender: Any) {
        flux.noteAction.update(memo: memoTextView.text, record: record)
        clear()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        clear()
    }

    @IBAction func timeButtonTapped(_ sender: Any) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm", options: 0, locale: Locale(identifier: "ja_JP"))
        let memo = self.memoTextView.text
        self.memoTextView.text = (memo ?? "") + dateFormatter.string(from: now) + ": "
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.memoTextView.text = record.memo
        self.memoTextView.becomeFirstResponder()
        let now = record.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        let hour = String(record.hour)
        self.timeLabel.text = dateFormatter.string(from: now) + "  " + hour + "時"
        memoTextView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Do any additional setup after loading the view.

    func clear() {
        self.dismiss(animated: true, completion: nil)
        flux.noteAction.isEditable()
        flux.noteAction.clearMemoTapped()
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
