//
//  MainDispatcher.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2019/10/30.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MainDispatcher {
    //    let getBabies = PublishRelay<[Baby]>
    let updateSettings = PublishRelay<Settings>()
    let updateInitialBabyID = PublishRelay<Int>()
    let updateDailyRecords = PublishRelay<HourlyRecord>()
    let getRecords = PublishRelay<[HourlyRecord]>()
    //    let getDaliyRecords = PublishRelay<DailyRecord>()
    let getBabyID = PublishRelay<Int>()
    let getTheme = PublishRelay<Int>()
    let updateDate = PublishRelay<Date>()
}
