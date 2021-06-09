//
//  MainAction.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2019/10/30.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import SwiftDate

final class MainAction {
    private let dispatcher: MainDispatcher
    private let disposeBag = DisposeBag()

    init(dispatcher: MainDispatcher) {
        self.dispatcher = dispatcher
    }

    func updateInitialBabyID(newInitialBabyID: Int) {
        try! Settings.update(updatedKeys: .initialBabyID(newInitialBabyID))
        dispatcher.updateInitialBabyID.accept(newInitialBabyID)
        print("updateInitialBabyID ", newInitialBabyID)
        //        try! Settings.update(updatedKeys: .initialBabyID(newInitialBabyID))
        //        dispatcher.updateInitialBabyID.accept(newInitialBabyID)
        //        let records = try! HourlyRecord.get(babyID: newInitialBabyID, date: Date())
        //        dispatcher.updateDailyRecords.accept(records.)
    }

    func updateDate(by date: Date) {
        dispatcher.updateDate.accept(date)
        print("mainAction updateDate", date)
    }

    func getRecords(by date: Date) {
        //        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let s = try! Settings.get()
        let records = try! HourlyRecord.get(babyID: s!.initialBabyID, date: date)
        dispatcher.getRecords.accept(records)
    }

    //    func getDailyRecords(by date: Date) {
    //        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    //        let s = try! Settings.get()
    //        let _records = try! DailyRecord.get(babyID: s!.initialBabyID, date: modifiedDate)
    //        guard let records: DailyRecord = _records else { return }
    //        dispatcher.getDaliyRecords.accept(records)
    //    }

    func getTheme() {
        let s = try! Settings.get()
        let initialBabyID: Int = s?.initialBabyID ?? 0
        let _baby = try! Baby.get(id: initialBabyID)
        guard let baby = _baby else { return }
        dispatcher.getTheme.accept(baby.theme.rawValue)
    }

    func getBabyID() {
        let _s = try! Settings.get()
        guard let s = _s else { return }
        dispatcher.getBabyID.accept(s.initialBabyID)
    }
}
