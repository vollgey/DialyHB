//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class NoteAction {
    private let dispatcher: NoteDispatcher
    private let disposeBag = DisposeBag()

    init(dispatcher: NoteDispatcher) {
        self.dispatcher = dispatcher
    }

    func getHourlyRecords(babyID: Int, date: Date) {
        let hourlyRecords = try! HourlyRecord.get(babyID: babyID, date: date)
        dispatcher.updateHourlyRecords.accept(hourlyRecords)
    }

    func getDailyRecords(babyID: Int, date: Date) {
        let record = try! DailyRecord.get(babyID: babyID, date: date)
        dispatcher.updateDaliyRecords.accept(record)
    }

    func updateDate(by date: Date) {
        dispatcher.updateDate.accept(date)
        print("noteAction updateDate", date)
    }

    func update(comment: String, record: DailyRecord) {
        let record = record
        record.comment = comment
        try! record.save(.comment)
        dispatcher.createDaliyComment.accept(record)
    }

    func update(babyId: Int, comment: String, date: Date) {
        let record = DailyRecord(babyID: babyId, date: date, comment: comment)
        try! record.save(.comment)
        dispatcher.createDaliyComment.accept(record)
    }

    func update(sleep: Sleep?, record: HourlyRecord) {
        var record = record
        record.sleep = sleep
        try! record.save(.sleep)
        dispatcher.updateHourlyRecord.accept(record)
        print("updatedSleep")
    }

    func update(milk: Milk?, record: HourlyRecord) {
        var record = record
        record.milk = milk
        try! record.save(.milk)
        dispatcher.updateHourlyRecord.accept(record)
        print("updatedMilk")
    }

    func update(diaper: Diaper?, record: HourlyRecord) {
        var record = record
        record.diaper = diaper
        try! record.save(.diaper)
        dispatcher.updateHourlyRecord.accept(record)
        print("updatedDiaper")
    }

    func update(memo: String?, record: HourlyRecord) {
        var record = record
        record.memo = memo
        try! record.save(.memo)
        dispatcher.updateHourlyRecord.accept(record)
    }

    func commentTapped(babyID: Int, date: Date, comment: String) {
        let record = DailyRecord(babyID: babyID, date: date, comment: comment)
        dispatcher.updateDaliyRecords.accept(record)
    }

    func commentTapped(record: DailyRecord) {
        dispatcher.dailyComment.accept(record)
    }

    func memoTapped(recrod: HourlyRecord) {
        dispatcher.memo.accept(recrod)
    }

    func longTap(type: PopoverType, record: HourlyRecord) {
        dispatcher.longTap.accept((type, record))
    }

    func clearLongTap() {
        dispatcher.longTap.accept((nil, nil))
    }

    func longPress() {
        dispatcher.longPress.accept(Void())
    }

    func clearCommentTapped() {
        dispatcher.dailyComment.accept(nil)
    }

    func clearMemoTapped() {
        dispatcher.memo.accept(nil)
    }

    func isEditable() {
        dispatcher.isEditable.accept(Void())
    }

    func nextPage() {

    }

    func updateFirstDate(date: Date) {
        dispatcher.updateFirstDate.accept(date)
    }

    func updateLastDate(date: Date) {
        dispatcher.updateLastDate.accept(date)
    }
}
