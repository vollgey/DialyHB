//
// Created by BadApple on 2019-07-31.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class BabyAction {
    private let dispatcher: BabyDispatcher
    private let disposeBag = DisposeBag()

    init(dispatcher: BabyDispatcher) {
        self.dispatcher = dispatcher
    }

    func getBabies() {
        let babies = try! Baby.getAll()
        dispatcher.updateBabies.accept(babies)
    }
}
