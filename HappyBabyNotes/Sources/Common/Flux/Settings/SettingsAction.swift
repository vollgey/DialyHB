//
// Created by BadApple on 2019-07-29.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class SettingsAction {

    private let dispatcher: SettingsDispatcher
    private let disposeBag = DisposeBag()

    init(dispatcher: SettingsDispatcher) {
        self.dispatcher = dispatcher
    }

    func getSettingsAndBabies() {
        let settings = try! Settings.get()!
        dispatcher.updateSettings.accept(settings)

        let babies = try! Baby.getAll()
        dispatcher.getBabies.accept(babies)
    }

    func update(settings: Settings, sleepUnit: SleepUnit) {
        var settings = settings
        settings.sleepUnit = sleepUnit
        try! settings.save(updatedKeys: .sleepUnit)
        dispatcher.updateSettings.accept(settings)
    }

    func update(isOn: Bool) {
        try! Settings.update(isOn: isOn)
        dispatcher.updateis24HClockNotation.accept(isOn)
    }

    func update(sleepUnit: SleepUnit) {
        try! Settings.update(sleepUnit: sleepUnit)
        dispatcher.updateSleepUnit.accept(sleepUnit)
    }

    func update(BabyID: Int, name: String) {
        try! Baby.update(id: BabyID, name: name)
        dispatcher.updateBabyName.accept((BabyID, name))
    }

    func update(BabyID: Int, theme: Theme) {
        try! Baby.update(id: BabyID, theme: theme)
        dispatcher.updateThemeColler.accept((BabyID, theme))
    }

    func update(BabyID: Int, birthday: Date) {
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: birthday)!
        try! Baby.update(id: BabyID, birthday: modifiedDate)
        dispatcher.updateBirthday.accept((BabyID, birthday))
    }

    func newBabyCellTapped() {
        dispatcher.selectedNewBabyCell.accept(Void())
    }

    func addBaby() {
        let nextBabyID = try! Baby.getNextBabyID()
        var baby = Baby(id: nextBabyID, name: "Baby", birthday: Date(), theme: .white)
        try! baby.insert()
        dispatcher.addBaby.accept(baby)
        print(baby)
    }

    func sleepCellTapped() {
        dispatcher.selectedSleepCell.accept(Void())
    }

    func babyCellTapped(BabyID: Int) {
        dispatcher.selectedBabyCell.accept(BabyID)
    }

    func birthDayCellTapped(BabyID: Int) {
        dispatcher.selectedBirthDayCell.accept(BabyID)
    }

    func themeCellTapped(BabyID: Int) {
        dispatcher.selectedthemeCell.accept(BabyID)
    }

    //PublishRelayの中身をnilにする
    func clearSelectedBaby() {
        dispatcher.selectedBabyCell.accept(nil)
    }

    func clearSelectedSleep() {
        dispatcher.selectedSleepCell.accept(nil)
    }

    func clearSelectedBirthDay() {
        dispatcher.selectedBirthDayCell.accept(nil)
    }

    func clearSlectedTheme() {
        dispatcher.selectedthemeCell.accept(nil)
    }

    func clearSlectedNewBaby() {
        dispatcher.selectedNewBabyCell.accept(nil)
    }

}
