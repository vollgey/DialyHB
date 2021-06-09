//
// Created by BadApple on 2019-07-29.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class SettingsDispatcher {
    let getBabies = PublishRelay<[Baby]>()
    let updateSettings = PublishRelay<Settings>()
    let updateis24HClockNotation = PublishRelay<Bool>()
    let updateSleepUnit = PublishRelay<SleepUnit>()
    let updateBabyName = PublishRelay<(Int, String)>()
    let updateThemeColler = PublishRelay<(Int, Theme)>()
    let updateBirthday = PublishRelay<(Int, Date)>()
    let selectedSleepCell = PublishRelay<Void?>()
    let selectedBabyCell = PublishRelay<Int?>()
    let selectedthemeCell = PublishRelay<Int?>()
    let selectedBirthDayCell = PublishRelay<Int?>()
    let selectedNewBabyCell = PublishRelay<Void?>()
    let addBaby = PublishRelay<Baby?>()
}
