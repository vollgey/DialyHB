//
// Created by BadApple on 2019-06-11.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SwiftDate

//class SettingsViewModel {
//    let flux: Flux
//    private let disposeBag = DisposeBag()
//    let babyValue: Value<BabyStore>
//    private let settings: Observable<Settings>
//    let output: Output

//    init(flux: Flux) {
//        self.flux = flux
//        babyValue = flux.babyStore.value

//        settings = flux.settingsStore.settings.filter { $0 != nil }.map { $0! }.share(replay: 1)
//
//        self.output = Output(
//                is24HClockNotation: settings
//                        .map { $0.is24HClockNotation }
//                        .distinctUntilChanged()
//                        .asDriver(onErrorDriveWith: Driver.empty())
//                sleepUnitText: settings
//                        .map { $0.sleepUnit }
//                        .distinctUntilChanged()
//                        .map {
//                            switch $0 {
//                            case .threeTypes:
//                                return "30分（3パターン）"
//                            case .sevenTypes:
//                                return "15分（7タイプ）"
//                            case .thirteenTypes:
//                                return "15分（13パターン）"
//                            }
//                        }
//                        .asDriver(onErrorDriveWith: Driver.empty()),
//                reloadData: Signal.just(Void())
//                sleepUnitTapped:Signal.just(Void())

//      )

//    }

// ViewからViewModelへBindする
//    func configure(is24HClockNotationSwitch: Observable<Bool>) {
//        is24HClockNotationSwitch
//                .skip(1)
//                .withLatestFrom(settings) { ($0, $1) }
//                                .withLatestFrom(settings) { v1, v2 in
//                                    (v1, v2) }
//                .subscribe(onNext: { [unowned flux] is24HClockNotation, settings in
//                    flux.settingsAction.update(settings: settings, is24HClockNotation: is24HClockNotation)
//                    print("changed")
//                })
//                .disposed(by: disposeBag)
//    }
//}

//extension SettingsViewModel {
//    struct Output {
//        let is24HClockNotation: Driver<Bool>
//        let sleepUnitText: Driver<String>
//        let reloadData: Signal<Void>
//    }
//}
