//
// Created by BadApple on 2019-06-28.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    init(flux: Flux) {
        flux.settingsAction.getSettingsAndBabies()
        flux.babyAction.getBabies()
    }
}

extension MainViewModel {
    struct Output {
        let settings: Observable<Settings>
    }
}
