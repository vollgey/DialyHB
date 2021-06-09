//
//  CommentViewController.swift
//  HappyBabyNotes
//
//  Created by 辻本英雄 on 2020/11/18.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!

    let flux: Flux
    let record: DailyRecord

    init(flux: Flux, record: DailyRecord) {
        self.flux = flux
        self.record = record
        super.init(nibName: CommentViewController.className, bundle: nil)
    }

    deinit {
        clear()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveButton.setTitle("Save", for: . normal)

        self.commentTextView.text = record.comment
        self.commentTextView.becomeFirstResponder()

        let date = dateFormat(record: record)
        self.dateLabel.text = date

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        flux.noteAction.update(comment: self.commentTextView.text, record: record)
        clear()
    }

    func dateFormat(record: DailyRecord) -> String {
        let date = self.record.date
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    func clear() {
        self.dismiss(animated: true, completion: nil)
        flux.noteAction.isEditable()
        flux.noteAction.clearCommentTapped()
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
