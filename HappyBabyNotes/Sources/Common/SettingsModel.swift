//
// Created by BadApple on 2019-06-24.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

//class SettingsModel {
//    let babyModels: [BabyModel]
//
//    private let settings: Settings
//
//    let output: Output
//
//    var language: Language {
//        return settings.language
//    }
//    var initialManNumber: Int {
//        return settings.initialManNumber
//    }
//    var is24HClockNotation: Bool {
//        return settings.is24HClockNotation
//    }
//    var sleepUnit: SleepUnit {
//        return settings.sleepUnit
//    }
//
//    private let _language: BehaviorRelay<Language>
//    private let _initialManNumber: BehaviorRelay<Int>
//    private let _is24HClockNotation: BehaviorRelay<Bool>
//    private let _sleepUnit: BehaviorRelay<SleepUnit>
//
//    private let disposeBag = DisposeBag()
//
//    init() {
//        settings = try! Settings.get()!
//
//        _language = BehaviorRelay(value: settings.language)
//        _initialManNumber = BehaviorRelay(value: settings.initialManNumber)
//        _is24HClockNotation = BehaviorRelay(value: settings.is24HClockNotation)
//        _sleepUnit = BehaviorRelay(value: settings.sleepUnit)
//
//        babyModels = try! Baby.get().map(BabyModel.init(baby:))
//
//        output = Output(
//                language: _language.asObservable(),
//                initialManNumber: _initialManNumber.asObservable(),
//                is24HClockNotation: _is24HClockNotation.asObservable(),
//                sleepUnit: _sleepUnit.asObservable()
//        )
//    }
//
//    func update(is24HClockNotation: Bool) {
//        settings.is24HClockNotation = is24HClockNotation
//        try! settings.update()
//        self._is24HClockNotation.accept(is24HClockNotation)
//    }
//
//    func update(sleepUnit: SleepUnit) {
//        settings.sleepUnit = sleepUnit
//        try! settings.update()
//        self._sleepUnit.accept(sleepUnit)
//    }
//}
//
//extension SettingsModel {
//    struct Output {
//        let language: Observable<Language>
//        let initialManNumber: Observable<Int>
//        let is24HClockNotation: Observable<Bool>
//        let sleepUnit: Observable<SleepUnit>
//    }
//}

//class SettingsModel {
//    private let _settings: BehaviorRelay<Settings>
//    let settings: Observable<Settings>
//    private let _babies: BehaviorRelay<[Baby]>
//    let babies: Observable<[Baby]>
//
//    let currentBaby: Observable<Baby>
//
//    var babiesValue: [Baby] {
//        return _babies.value
//    }
//
//    private let disposeBag = DisposeBag()
//
//    init() {
//        _settings = BehaviorRelay(value: try! Settings.get()!)
//        settings = _settings.asObservable()
//
//        _babies = BehaviorRelay(value: try! Baby.get())
//        babies = _babies.asObservable()
//
//        currentBaby = Observable.combineLatest(settings, babies)
//                .map { $1[$0.initialBabyID] }
//                .share()
//    }
//
//    func update(is24HClockNotation: Bool) {
//        let settings = _settings.value
//        settings.is24HClockNotation = is24HClockNotation
//        try! settings.save()
//        _settings.accept(settings)
//    }
//
//    func update(sleepUnit: SleepUnit) {
//        let settings = _settings.value
//        settings.sleepUnit = sleepUnit
//        try! settings.save()
//        _settings.accept(settings)
//    }
//
//    func update(language: Language) {
//        let settings = _settings.value
//        settings.language = language
//        try! settings.save()
//        _settings.accept(settings)
//    }
//
//    func update(initialBabyID: Int) {
//        let settings = _settings.value
//        settings.initialBabyID = initialBabyID
//        try! settings.save()
//        _settings.accept(settings)
//    }
//
//    func update(babyID: Int, name: String) {
//        let babies = _babies.value
//        babies[babyID].name = name
//        try! babies[babyID].save()
//        _babies.accept(babies)
//    }
//
//    func update(babyID: Int, birthday: Date) {
//        let babies = _babies.value
//        babies[babyID].birthday = birthday
//        try! babies[babyID].save()
//        _babies.accept(babies)
//    }
//
//    func update(babyID: Int, theme: Theme) {
//        let babies = _babies.value
//        babies[babyID].theme = theme
//        try! babies[babyID].save()
//        _babies.accept(babies)
//    }
//}

//class SettingsModel {
//
//    let response: Observable<(Settings, [Baby])>
//
//    private let _getSettings = PublishRelay<Void>()
//
//    private let _updateSettings = PublishRelay<(Settings, [Baby])>()
//
//    private let disposeBag = DisposeBag()
//
//    init() {
//        response = _getSettings.map {
//                    (try! Settings.get()!, try! Baby.get())
//                }
//                .share()
//    }
//
//    func get() {
//        _getSettings.accept(Void())
//    }
//
//    func update(sleepUnit: SleepUnit, settings: Settings) {
//        settings.sleepUnit = sleepUnit
//
//    }
//
//    func update(is24HClockNotation: Bool) {
//    }
//
//    func update(sleepUnit: SleepUnit) {
//        _updateSleepUnit.accept(sleepUnit)
//    }
//
//    func update(language: Language) {
//        let settings = _getSettings.value
//        settings.language = language
//        try! settings.save()
//        _getSettings.accept(settings)
//    }
//
//    func update(initialBabyID: Int) {
//        let settings = _getSettings.value
//        settings.initialBabyID = initialBabyID
//        try! settings.save()
//        _getSettings.accept(settings)
//    }
//
//    func update(babyID: Int, name: String) {
//        let baby = _babies[babyID].value
//        baby.name = name
//        try! baby.save()
//        _babies[babyID].accept(baby)
//    }
//
//    func update(babyID: Int, birthday: Date) {
//        let baby = _babies[babyID].value
//        baby.birthday = birthday
//        try! baby.save()
//        _babies[babyID].accept(baby)
//    }
//
//    func update(babyID: Int, theme: Theme) {
//        let baby = _babies[babyID].value
//        baby.theme = theme
//        try! baby.save()
//        _babies[babyID].accept(baby)
//    }
//}
