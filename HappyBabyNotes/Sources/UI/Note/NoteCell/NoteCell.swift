//
//  DateCell.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 Cellの情報を統括するファイル.
 ***/

import UIKit
import RxSwift
import RxCocoa

class NoteCell: CollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var milkButton: UIButton!
    @IBOutlet weak var diaperButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!

    var viewModel: NoteCellViewModel!

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        timeLabel.layer.borderWidth = 0.2
        timeLabel.layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }

    func configure(flux: Flux, hour: Int) {
        //time
        timeLabel.text = String(hour)
        //sleep
        flux.noteStore.hourlyRecords.map {
            (hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            //            print($0.sleep?.uiImageArray)
            self.animate(nextImageArray: $0.sleep?.uiImageArray, button: self.sleepButton)
        }).disposed(by: disposeBag)

        self.sleepButton.rx.tap.withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            print("-----sleepButton------")
            flux.noteAction.update(sleep: $0.sleep.next(), record: $0)
            print($0)
        }).disposed(by: disposeBag)

        //milk
        self.milkButton.rx.tap.withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            print("-----milkButton------")
            flux.noteAction.update(milk: $0.milk.next(), record: $0)
            print($0)
        }).disposed(by: disposeBag)

        flux.noteStore.hourlyRecords.map {
            (hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.mainStore.value.mainDate!, hour: hour)
        }.sample(self.milkButton.rx.tap.startWith(Void())).subscribe(onNext: {
            self.animate(nextImageArray: $0.milk?.uiImageArray, button: self.milkButton)
        }).disposed(by: disposeBag)

        //diaper

        self.diaperButton.rx.tap.withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            print("-----diaperButton------")
            flux.noteAction.update(diaper: $0.diaper.next(), record: $0)
            print($0)
        }).disposed(by: disposeBag)

        flux.noteStore.hourlyRecords.map {
            (hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.sample(self.diaperButton.rx.tap.startWith(Void())).subscribe(onNext: {
            self.animate(nextImageArray: $0.diaper?.uiImageArray, button: self.diaperButton)
        }).disposed(by: disposeBag)

        //長押しの処理
        self.diaperButton.rx.controlEvent(.touchDown).sample(flux.noteStore.longPress).withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            flux.noteAction.longTap(type: .diaper, record: $0)
        }).disposed(by: disposeBag)

        self.milkButton.rx.controlEvent(.touchDown).sample(flux.noteStore.longPress).withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            flux.noteAction.longTap(type: .milk, record: $0)
        }).disposed(by: disposeBag)

        self.sleepButton.rx.controlEvent(.touchDown).sample(flux.noteStore.longPress).withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            flux.noteAction.longTap(type: .sleep, record: $0)
        }).disposed(by: disposeBag)

        //メモ欄
        flux.noteStore.hourlyRecords.map {
            (hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first
                ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            self.memoTextView.text = $0.memo
        }).disposed(by: disposeBag)

        memoTextView.rx.didBeginEditing.withLatestFrom(flux.noteStore.hourlyRecords) {
            (_: Void, hourlyRecords: [HourlyRecord]) -> HourlyRecord in
            hourlyRecords.filter({ $0.hour == hour }).first ?? HourlyRecord(manNumber: flux.mainStore.value.babyID!, date: flux.noteStore.value.noteDate!, hour: hour)
        }.subscribe(onNext: {
            self.memoTextView.isEditable = false
            flux.noteAction.memoTapped(recrod: $0)
        }).disposed(by: disposeBag)

        flux.noteStore.isEditable.subscribe(onNext: {e in
            guard e != nil else { return }
            self.memoTextView.isEditable = true

        }).disposed(by: disposeBag)

    }

    //    func configure(flux: Flux, hour: Int) {
    //        viewModel = NoteCellViewModel(flux: flux, hour: hour,
    //                                      input: (
    //                                                  sleepButtonTap: sleepButton.rx.tap.asObservable(),
    //                                                  milkButtonTap: milkButton.rx.tap.asObservable(),
    //                                                  diaperButtonTap: diaperButton.rx.tap.asObservable()
    //                                      )
    //        )
    //
    //        milkButton.rx.tap
    //            .withLatestFrom(flux.noteStore.hourlyRecords) { _, HR in
    //                return HR
    //        }.subscribe {
    //            print($0)
    //        }.disposed(by: disposeBag)
    //
    //
    ////        milkButton.rx.tap.withLatestFrom(flux.noteStore.hourlyRecords) { _, HR in
    ////            HR[hour].milk
    ////
    ////        }
    ////            .subscribe({ _,  in
    ////            flux.noteAction.update(milk: <#T##Milk?#>, record: <#T##HourlyRecord#>)}).disposed(by: disposeBag)
    //        //milkButtonをタップしたとき
    //
    //
    ////
    ////        sleepButton.setImage(viewModel.output.sleep.map{$0?.uiImageArray.last}, for: .normal)
    ////        milkButton.setImage(viewModel.output.milk.uiImageArray.last, for: .normal)
    ////        diaperButton.setImage(viewModel.output.diaper.uiImageArray.last, for: .normal)
    //
    //        viewModel.output.sleep.drive(sleep).disposed(by: disposeBag)
    //        viewModel.output.milk.drive(milk).disposed(by: disposeBag)
    //        viewModel.output.diaper.drive(diaper).disposed(by: disposeBag)
    //    }

    //    private var sleep: Binder<Sleep?> {
    //        return Binder(sleepButton) { sleepButton, sleep in
    //            NoteCell.animate(nextImageArray: sleep?.uiImageArray, button: sleepButton)
    //        }
    //    }
    //
    //    private var milk: Binder<Milk?> {
    //        return Binder(milkButton) { milkButton, milk in
    //            NoteCell.animate(nextImageArray: milk?.uiImageArray, button: milkButton)
    //        }
    //    }
    //
    //    private var diaper: Binder<Diaper?> {
    //        return Binder(diaperButton) { button, diaper in
    //            NoteCell.animate(nextImageArray: diaper?.uiImageArray, button: button)
    //        }
    //    }

    func animate(nextImageArray: [UIImage]?, button: UIButton) {
        //    print("animated")
        guard let imageView = button.imageView else { return }

        if let imageArray = nextImageArray { // 次の画像がnilでない時
            let animateClosure = {
                imageView.animationImages = imageArray
                imageView.animationDuration = 1.0
                imageView.animationRepeatCount = 1
                imageView.startAnimating()
                button.setImage(imageArray.last, for: .normal)
            }

            if imageView.isAnimating {
                imageView.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: animateClosure)
            } else {
                animateClosure()
            }
        } else { // 次の画像がnilの時
            if imageView.isAnimating {
                imageView.stopAnimating()
            }
            button.setImage(.none, for: .normal)
        }
    }
}

extension NoteCell {
    func selectButton (type: PopoverType) -> UIButton {
        switch  type {
        case .sleep:
            return sleepButton

        case .milk:
            return milkButton

        case .diaper:
            return diaperButton

        }
    }
}
