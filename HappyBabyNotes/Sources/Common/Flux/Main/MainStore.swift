//
//  MainStore.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2019/10/30.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MainStore {
    private let _main = BehaviorRelay < String
    >(value: "太郎")
    let main: Observable<String>
    //    let getBabies: Observable<Baby?>
    //    fileprivate let _getBabies = BehaviorRelay<Baby?>(value: nil)
    let updateSettings: Observable<Settings?>
    fileprivate let _updateSettings = BehaviorRelay<Settings?>(value: nil)
    let updateInitialBabyID: Observable<Int?>
    fileprivate let _updateInitialBabyID = BehaviorRelay<Int?>(value: nil)
    let updateDailyRecords: Observable<HourlyRecord?>
    fileprivate let _updateDailyRecords = BehaviorRelay<HourlyRecord?>(value: nil)

    let getRecords: Observable<[HourlyRecord]?>
    fileprivate let _getRecords = BehaviorRelay<[HourlyRecord]?>(value: nil)
    //    let getDailyRecords: Observable<DailyRecord?>
    //    fileprivate let _getDailyRecords = BehaviorRelay<DailyRecord?>(value: nil)

    let date: Observable<Date>
    fileprivate let _date = BehaviorRelay<Date>(value: Date())
    let getBabyID: Observable<Int>
    fileprivate let _getBabyID = BehaviorRelay<Int>(value: 0)
    let getTheme: Observable<Int>
    fileprivate let _getTheme = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()

    init(dispatcher: MainDispatcher) {
        self.main = _main.asObservable()
        //        self.getBabies = _getBabies.asObservable()
        self.updateSettings = _updateSettings.asObservable()
        self.updateInitialBabyID = _updateInitialBabyID.asObservable()
        self.updateDailyRecords = _updateDailyRecords.asObservable()
        self.getRecords = _getRecords.asObservable()
        //        self.getDailyRecords = _getDailyRecords.asObservable()
        self.date = _date.asObservable()
        self.getBabyID = _getBabyID.asObservable()
        self.getTheme = _getTheme.asObservable()

        //        dispatcher.getBabies
        //            .bind(to: _getBabies)
        //            .disposed(by: disposeBag)

        dispatcher.updateSettings
            .bind(to: _updateSettings)
            .disposed(by: disposeBag)

        dispatcher.updateInitialBabyID
            .bind(to: _getBabyID)
            .disposed(by: disposeBag)

        dispatcher.updateDailyRecords
            .bind(to: _updateDailyRecords)
            .disposed(by: disposeBag)

        self.getBabyID.subscribe {
            print("storeBabyID ", $0)
        }.disposed(by: disposeBag)

        dispatcher.getRecords
            .bind(to: _getRecords)
            .disposed(by: disposeBag)

        //        dispatcher.getDaliyRecords
        //            .bind(to: _getDailyRecords)
        //            .disposed(by: disposeBag)

        dispatcher.getRecords.subscribe {
            print("getRecords", $0)
        }.disposed(by: disposeBag)

        dispatcher.getBabyID
            .bind(to: _getBabyID)
            .disposed(by: disposeBag)

        dispatcher.getTheme
            .bind(to: _getTheme)
            .disposed(by: disposeBag)

        dispatcher.updateDate
            .bind(to: _date)
            .disposed(by: disposeBag)

        dispatcher.updateDate.subscribe {
            print("mainStore updateDate", $0)
        }.disposed(by: disposeBag)

    }
}

extension MainStore: ValueCompatible { }

extension Value where Base == MainStore {
    var mainDate: Date? {
        base._date.value
    }

    var babyID: Int? {
        base._getBabyID.value
    }

    var theme: Int? {
        base._getTheme.value
    }

}
