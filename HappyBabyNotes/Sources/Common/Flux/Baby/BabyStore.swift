//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class BabyStore {

    fileprivate let _babies = BehaviorRelay<[Baby]>(value: [])
    let babies: Observable<[Baby]>

    private let disposeBag = DisposeBag()

    init(dispatcher: BabyDispatcher) {
        babies = _babies.asObservable()

        dispatcher.updateBabies
            .do(onNext: { _ in print("babies updated") })
            .bind(to: _babies)
            .disposed(by: disposeBag)
    }
}

extension BabyStore: ValueCompatible {}

extension Value where Base == BabyStore {
    var babies: [Baby] {
        base._babies.value
    }
}
