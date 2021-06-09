//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class NoteStore {
    fileprivate let _dailyRecord = BehaviorRelay<DailyRecord?>(value: nil)
    let dailyRecord: Observable<DailyRecord?>

    fileprivate var _hourlyRecords = BehaviorRelay<[HourlyRecord]>(value: [])
    let hourlyRecords: Observable<[HourlyRecord]>

    fileprivate var _createDaliyComment = BehaviorRelay<DailyRecord?>(value: nil)
    let createDaliyComment: Observable<DailyRecord?>

    fileprivate var _dailyComment = BehaviorRelay<DailyRecord?>(value: nil)
    let dailyComment: Observable<DailyRecord?>

    fileprivate let _date = BehaviorRelay<Date>(value: Date())
    let date: Observable<Date>

    private let _comment = BehaviorRelay<String?>(value: nil)
    let comment: Observable<String?>

    private let _memo = BehaviorRelay<HourlyRecord?>(value: nil)
    let memo: Observable<HourlyRecord?>

    private let _isEditable = BehaviorRelay<Void?>(value: nil)
    let isEditable: Observable<Void?>

    private let _longTap = BehaviorRelay<(PopoverType?, HourlyRecord?)>(value: (nil, nil))
    let longTap: Observable<(PopoverType?, HourlyRecord?)>

    private let _longPress = BehaviorRelay<Void?>(value: nil)
    let longPress: Observable<Void?>

    fileprivate let _firstDate = BehaviorRelay<Date>(value: Date())
    let firstDate: Observable<Date>

    fileprivate let _lastDate = BehaviorRelay<Date>(value: Date())
    let lastDate: Observable<Date>

    private let disposeBag = DisposeBag()

    init(dispatcher: NoteDispatcher) {
        dailyRecord = _dailyRecord.asObservable()
        hourlyRecords = _hourlyRecords.asObservable()
        createDaliyComment = _createDaliyComment.asObservable()
        date = _date.asObservable()
        comment = _comment.asObservable()
        memo = _memo.asObservable()
        dailyComment = _dailyComment.asObservable()
        isEditable = _isEditable.asObservable()
        longTap = _longTap.asObservable()
        longPress = _longPress.asObservable()
        firstDate = _firstDate.asObservable()
        lastDate = _lastDate.asObservable()

        dispatcher.updateHourlyRecords
            .bind(to: _hourlyRecords)
            .disposed(by: disposeBag)

        dispatcher.updateDaliyRecords
            .bind(to: _dailyRecord)
            .disposed(by: disposeBag)

        dispatcher.createDaliyComment
            .bind(to: _dailyRecord)
            .disposed(by: disposeBag)

        dispatcher.memo
            .bind(to: _memo)
            .disposed(by: disposeBag)

        dispatcher.dailyComment
            .bind(to: _dailyComment)
            .disposed(by: disposeBag)

        dispatcher.isEditable
            .bind(to: _isEditable)
            .disposed(by: disposeBag)

        dispatcher.longTap
            .bind(to: _longTap)
            .disposed(by: disposeBag)

        dispatcher.longPress
            .bind(to: _longPress)
            .disposed(by: disposeBag)

        dispatcher.updateDate
            .bind(to: _date)
            .disposed(by: disposeBag)

        dispatcher.updateFirstDate
            .bind(to: _firstDate)
            .disposed(by: disposeBag)

        dispatcher.updateLastDate
            .bind(to: _lastDate)
            .disposed(by: disposeBag)

        dispatcher.updateHourlyRecord
            .withLatestFrom(_hourlyRecords) { record, records -> [HourlyRecord] in
                var records = records
                var record = record
                if !record.created {
                    record.setCreated()
                    records.append(record)
                } else {
                    if let firstIndex = records.firstIndex(of: record) {
                        records[firstIndex] = record
                    }
                }
                return records
            }
            .bind(to: _hourlyRecords)
            .disposed(by: disposeBag)
    }
}

extension NoteStore: ValueCompatible { }

extension Value where Base == NoteStore {
    var noteDate: Date? {
        base._date.value
    }

    var dailyRecord: DailyRecord? {
        base._dailyRecord.value
    }

    var firstDate: Date? {
        base._firstDate.value
    }

    var lastDate: Date? {
        base._lastDate.value
    }

}
