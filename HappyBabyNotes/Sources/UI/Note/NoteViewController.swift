//
//  DateViewController.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 24時間のCellを操作するファイル.
 ***/

import UIKit
import SwiftDate
import RxSwift
import RxCocoa
import RxRelay

class NoteViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    // CalendarのCollectionView
    @IBOutlet weak var dateCollectionView: UICollectionView!
    // CollectionViewのCellを調整するFlowLayout
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    // CollectionViewの高さを決めるConstraint
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    // CommentのTextView
    @IBOutlet weak var commentTextView: UITextView!

    @IBOutlet weak var commentLabel: UILabel!

    let viewModel: NoteViewModel
    let dataSource: NoteViewDataSource
    let flux: Flux
    var date: Date
    var number: Int = 0
    var count: Int = 0

    var isLoaded = false

    let disposeBag = DisposeBag()

    init(flux: Flux, date: Date) {
        self.date = date
        self.flux = flux
        viewModel = NoteViewModel(flux: flux)
        dataSource = NoteViewDataSource(flux: flux)

        super.init(nibName: NoteViewController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        commentLabel.text = "コメント"

        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        flux.noteAction.getHourlyRecords(babyID: flux.mainStore.value.babyID!, date: date)
        flux.noteAction.getDailyRecords(babyID: flux.mainStore.value.babyID!, date: date)

        dataSource.configure(with: dateCollectionView)

        //        let custombar = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width), height: 40))
        //        custombar.backgroundColor = UIColor.groupTableViewBackground
        //        let commitBtn = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width) - 100, y: 0, width: 80, height: 40))
        //        commitBtn.setTitle("閉じる", for: .normal)
        //        commitBtn.setTitleColor(UIColor.blue, for: .normal)
        //        commitBtn.addTarget(self, action: #selector(NoteViewController.onClickCommitButton), for: .touchUpInside)
        //        custombar.addSubview(commitBtn)
        //        commentTextView.inputAccessoryView = custombar
        //        commentTextView.keyboardType = .default
        commentTextView.delegate = self

        let longPressGesture =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(NoteViewController.longPress(_:)))

        longPressGesture.delegate = self
        self.view.addGestureRecognizer(longPressGesture)

        commentTextView.rx.didBeginEditing.withLatestFrom(flux.noteStore.dailyRecord) {
            (_: Void, dailyRecord: DailyRecord?) -> DailyRecord in
            dailyRecord ?? DailyRecord(babyID: self.flux.mainStore.value.babyID!, date: self.date, comment: "")
        }.subscribe(onNext: {
            self.commentTextView.isEditable = false
            self.flux.noteAction.commentTapped(record: $0)
        }).disposed(by: disposeBag)

        flux.noteStore.isEditable.subscribe(onNext: {e in
            self.commentTextView.text = self.flux.noteStore.value.dailyRecord?.comment
            guard e != nil else { return }
            self.commentTextView.isEditable = true
        }).disposed(by: disposeBag)

        //        commentTextView.rx.text.orEmpty.subscribe(onNext: { [unowned self]comment in
        //            if (self.flux.noteStore.value.dailyRecord?.comment) != nil {
        //                guard  let record = self.flux.noteStore.value.dailyRecord else { return }
        //                self.flux.noteAction.update(comment: comment, record: record)
        //            } else {
        //                switch self.count {
        //                case 0:
        //                    self.count += 1
        //                default:
        //                    self.flux.noteAction.update(babyId: self.flux.mainStore.value.babyID!, comment: comment, date: self.date)
        //                }
        //            }
        //        }).disposed(by: disposeBag)

        isLoaded = true

        flux.noteStore.dailyComment.subscribe(onNext: { record in
            guard let record = record else { return }
            let vc = CommentViewController(flux: self.flux, record: record)
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)

        flux.noteStore.memo.subscribe(onNext: { record in
            guard let record = record else { return }
            let vc = MemoViewController(flux: self.flux, record: record)
            //        self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true)

        }).disposed(by: disposeBag)

        flux.noteStore.longTap.subscribe(onNext: { type_record in
            guard let type = type_record.0 else { return }
            guard let record = type_record.1 else { return }
            let vc = PopoverViewController(flux: self.flux, type: type, record: record)
            self.present(vc, animated: true)
            //                        self.showPopoverView(type: type)
        }).disposed(by: disposeBag)
    }

    func onJumpNow() {

    }
    //
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.view.frame.origin.y == 0 {
    //                self.view.frame.origin.y -= keyboardSize.height * 3 / 4
    //            } else {
    //                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
    //                self.view.frame.origin.y -= suggestionHeight
    //            }
    //        }
    //    }
    //
    //    @objc func keyboardWillHide() {
    //        if self.view.frame.origin.y != 0 {
    //            self.view.frame.origin.y = 0
    //        }
    //    }

    @objc func onClickCommitButton (sender: UIButton) {
        if commentTextView.isFirstResponder {
            commentTextView.resignFirstResponder()
        }
    }

    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // 開始
            self.flux.noteAction.longPress()
        }
        //           else if sender.state == .ended {
        //             print("LongPress tap")
        //
        //        }
    }
}
