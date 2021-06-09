//
//  NoteModel.swift
//  HappyBabyNotes
//
//  Created by BadApple on 2019/06/18.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxRelay

//class NoteModel {
//
//    let hourlyRecords: Observable<[HourlyRecord]>
//    let date: Observable<Date>
//
//    private let disposeBag = DisposeBag()
//
//    init(settingsModel: SettingsModel) {
//
//        date = Observable.just(Date())
//
//        hourlyRecords = Observable.combineLatest(settingsModel.currentBaby, date)
//                .map { (baby: Baby, date: Date) in
//                    (baby, date, try! HourlyRecord.get(babyID: baby.id, date: date))
//                }.map { (baby, date, records) in
//                    (0...23).map { i in
//                        records.filter { $0.hour == i }.first ??
//                                HourlyRecord(manNumber: baby.id, date: date, hour: i,
//                                        sleep: nil, milk: nil, diaper: nil, memo: nil)
//                    }
//                }.share()
//    }
//
//    func update(comment: String?) {
//    }
//}
