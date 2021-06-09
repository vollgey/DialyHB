//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class NoteDispatcher {
    let getDailyRecord = PublishRelay<[DailyRecord]>()
    let updateHourlyRecords = PublishRelay<[HourlyRecord]>()
    let updateHourlyRecord = PublishRelay<HourlyRecord>()
    let updateDaliyRecords = PublishRelay<DailyRecord?>()
    let createDaliyComment = PublishRelay<DailyRecord?>()
    let dailyComment = PublishRelay<DailyRecord?>()
    let memo = PublishRelay<HourlyRecord?>()
    let isEditable = PublishRelay<Void?>()
    let updateDate = PublishRelay<Date>()
    let longTap = PublishRelay<(PopoverType?, HourlyRecord?)>()
    let longPress = PublishRelay<Void?>()
    let updateFirstDate = PublishRelay<Date>()
    let updateLastDate = PublishRelay<Date>()
}
