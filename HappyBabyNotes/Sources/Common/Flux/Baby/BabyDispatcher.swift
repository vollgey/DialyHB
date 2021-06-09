//
// Created by BadApple on 2019-07-29.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import RxSwift
import RxRelay

final class BabyDispatcher {
    let updateBabies = PublishRelay<[Baby]>()
    let updateIs24HClockNotation = PublishRelay<Bool>()
    let updateBabiesName = PublishRelay<String>()
    let updateTheme = PublishRelay<Theme>()
}
