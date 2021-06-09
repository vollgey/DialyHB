//
// Created by BadApple on 2019-07-29.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class SettingsStore {

    fileprivate let _settings = BehaviorRelay<Settings?>(value: nil)
    let settings: Observable<Settings?>

    fileprivate let _selectedBabyCell = BehaviorRelay<Int?>(value: nil)
    let selectedBabyCell: Observable<Int?>

    fileprivate let _selectedSleepCell = BehaviorRelay<Void?>(value: nil)
    let selectedSleepCell: Observable<Void?>

    fileprivate let _selectedBirthDayCell = BehaviorRelay<Int?>(value: nil)
    let selectedBirthDayCell: Observable<Int?>

    fileprivate let _selectedThemeCell = BehaviorRelay<Int?>(value: nil)
    let selectedThemeCell: Observable<Int?>

    fileprivate let _selectedNewBabyCell = BehaviorRelay<Void?>(value: nil)
    let selectedNewBabyCell: Observable<Void?>

    fileprivate let _addBaby = BehaviorRelay<Baby?>(value: nil)
    let addBaby: Observable<Baby?>

    fileprivate let _babies = BehaviorRelay<[Baby]>(value: [])
    let babies: Observable<[Baby]>

    private let disposeBag = DisposeBag()

    init(dispatcher: SettingsDispatcher, babyDispatcher: BabyDispatcher) {
        settings = _settings.asObservable()
        selectedBabyCell = _selectedBabyCell.asObservable()
        selectedSleepCell = _selectedSleepCell.asObservable()
        selectedBirthDayCell = _selectedBirthDayCell.asObservable()
        selectedThemeCell = _selectedThemeCell.asObservable()
        selectedNewBabyCell = _selectedNewBabyCell.asObservable()
        addBaby = _addBaby.asObservable()
        babies = _babies.asObservable()

        dispatcher.updateSettings
            .bind(to: _settings)
            .disposed(by: disposeBag)

        dispatcher.getBabies
            .bind(to: _babies)
            .disposed(by: disposeBag)

        dispatcher.selectedBabyCell
            .bind(to: _selectedBabyCell)
            .disposed(by: disposeBag)

        dispatcher.selectedBirthDayCell
            .bind(to: _selectedBirthDayCell)
            .disposed(by: disposeBag)

        dispatcher.selectedSleepCell
            .bind(to: _selectedSleepCell)
            .disposed(by: disposeBag)

        dispatcher.selectedthemeCell
            .bind(to: _selectedThemeCell)
            .disposed(by: disposeBag)

        dispatcher.selectedNewBabyCell
            .bind(to: _selectedNewBabyCell)
            .disposed(by: disposeBag)

        dispatcher.updateis24HClockNotation
            .withLatestFrom(_settings) { is24HClockNotation, settings -> Settings? in
                if var settings = settings {
                    settings.is24HClockNotation = is24HClockNotation
                    return settings
                }
                return nil
            }
            .bind(to: _settings)
            .disposed(by: disposeBag)

        dispatcher.updateSleepUnit
            .withLatestFrom(_settings) { sleepUnit, settings -> Settings? in
                if var settings = settings {
                    settings.sleepUnit = sleepUnit
                    return settings
                }
                return nil
            }
            .bind(to: _settings)
            .disposed(by: disposeBag)

        dispatcher.updateBabyName
            //Relayから流れてきたidとnameを新しくなっていないbabiesに渡す
            .withLatestFrom(_babies) { id_name, babies -> [Baby] in
                var babies = babies
                babies[id_name.0].name = id_name.1
                return babies
            }.bind(to: _babies)
            .disposed(by: disposeBag)

        dispatcher.updateThemeColler
            .withLatestFrom(_babies) { id_theme, babies -> [Baby] in
                var babies = babies
                babies[id_theme.0].theme = id_theme.1
                return babies
            }.bind(to: _babies)
            .disposed(by: disposeBag)

        dispatcher.updateBirthday
            .withLatestFrom(_babies) { id_birthday, babies -> [Baby] in
                var babies = babies
                babies[id_birthday.0].birthday = id_birthday.1
                return babies
            }.bind(to: _babies)
            .disposed(by: disposeBag)

        dispatcher.addBaby
            .withLatestFrom(_babies) { baby, babies -> [Baby] in
                var babies = babies
                if let baby = baby {
                    babies.append(baby)
                }
                return babies
                //      .withLatestFrom(_babies) {$1 + $0}
            }.bind(to: _babies)
            .disposed(by: disposeBag)
    }

}

extension SettingsStore: ValueCompatible { }

extension Value where Base == SettingsStore {
    var settings: Settings? {
        base._settings.value
    }

    var babies: [Baby] {
        base._babies.value
    }
}
