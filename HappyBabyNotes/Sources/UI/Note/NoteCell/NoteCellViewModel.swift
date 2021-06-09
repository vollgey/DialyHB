//
// Created by BadApple on 2019-06-19.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxCocoa
import RxRelay

class NoteCellViewModel {
    private let flux: Flux
    private let record: Observable<HourlyRecord>
    let output: Output

    private let disposeBag = DisposeBag()

    init(flux: Flux, hour: Int, input: Input) {
        self.flux = flux

        record = flux.noteStore.hourlyRecords
            .filter { $0.count == 24 }.map { $0[hour] }.share()

        // recordが流れてきてないのが原因
        //        input.milkButtonTap.subscribe({ _ in print("hoge") }).disposed(by: disposeBag)

        let action = flux.noteAction

        input.sleepButtonTap
            .withLatestFrom(record) { $1 }
            .subscribe(onNext: { record in
                action.update(sleep: record.sleep.next(), record: record)
            })
            .disposed(by: disposeBag)

        input.milkButtonTap
            .withLatestFrom(record) { $1 }
            .subscribe(onNext: { record in
                print("tapped")
                action.update(milk: record.milk.next(), record: record)
            })
            .disposed(by: disposeBag)

        output = Output(
            sleep: record.map { $0.sleep }.asDriver(onErrorDriveWith: Driver.empty()),
            milk: record.map { $0.milk }.asDriver(onErrorDriveWith: Driver.empty()),
            diaper: record.map { $0.diaper }.asDriver(onErrorDriveWith: Driver.empty()),
            memo: record.map { $0.memo }.asDriver(onErrorDriveWith: Driver.empty())
        )
    }
}

extension NoteCellViewModel {
    struct Output {
        let sleep: Driver<Sleep?>
        let milk: Driver<Milk?>
        let diaper: Driver<Diaper?>
        let memo: Driver<String?>
    }

    typealias Input = (
        sleepButtonTap: Observable<Void>,
        milkButtonTap: Observable<Void>,
        diaperButtonTap: Observable<Void>
    )
}
