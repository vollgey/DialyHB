//
// Created by BadApple on 2019-06-21.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxRelay

//class NoteCellModel {
//    private let record: HourlyRecord
//
//    let sleep: Observable<Sleep?>
//    let milk: Observable<Milk?>
//    let diaper: Observable<Diaper?>
//    let memo: Observable<String?>
//
//    var manNumber: Int {
//        return record.manNumber
//    }
//    var date: Date {
//        return record.date
//    }
//    var hour: Int {
//        return record.hour
//    }
//    var sleepValue: Sleep? {
//        return record.sleep
//    }
//    var milkValue: Milk? {
//        return record.milk
//    }
//    var diaperValue: Diaper? {
//        return record.diaper
//    }
//    var memoValue: String? {
//        return record.memo
//    }
//
//    private let _sleep: PublishRelay<Sleep?>
//    private let _milk: PublishRelay<Milk?>
//    private let _diaper: PublishRelay<Diaper?>
//    private let _memo: PublishRelay<String?>
//
//    private let disposeBag = DisposeBag()
//
//    init(hourlyRecords: Observable<[HourlyRecord]>, hour: Int) {
//        _sleep = PublishRelay()
//        _milk = PublishRelay()
//        _diaper = PublishRelay()
//        _memo = PublishRelay()
//
//        let record = hourlyRecords.map { $0[hour] }.share()
//
//        sleep = _sleep.asObservable()
//        milk = _milk.asObservable()
//        diaper = _diaper.asObservable()
//        memo = _memo.asObservable()
//
//        _sleep.subscribe { [unowned record] event in
//            guard let sleep = event.element else { return }
//            record.sleep = sleep
//            try! record.save(.sleep)
//        }.disposed(by: disposeBag)
//
//        _milk.subscribe { [unowned record] event in
//            guard let milk = event.element else { return }
//            record.milk = milk
//            try! record.save(.milk)
//        }.disposed(by: disposeBag)
//
//        _diaper.subscribe { [unowned record] event in
//            guard let diaper = event.element else { return }
//            record.diaper = diaper
//            try! record.save(.diaper)
//        }.disposed(by: disposeBag)
//    }
//
//    func nextSleep() {
//        _sleep.accept(record.sleep.next())
//    }
//
//    func nextMilk() {
//        _milk.accept(record.milk.next())
//    }
//
//    func nextDiaper() {
//        _diaper.accept(record.diaper.next())
//    }
//
//    func update(memo: String?) {
//        _memo.accept(memo)
//    }
//}
