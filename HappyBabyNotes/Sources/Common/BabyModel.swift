//
//  BabyModel.swift
//  HappyBabyNotes
//
//  Created by BadApple on 2019/06/10.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

//class BabyModel {
//    private let _baby: BehaviorRelay<Baby>
//    let baby: Observable<Baby>
//
//    private let disposeBag = DisposeBag()
//
//    private let _updateSettings = PublishRelay<Baby>()
//
//    init(baby: Baby) {
//        _baby = BehaviorRelay(value: baby)
//        self.baby = _baby.asObservable()
//    }
//
//    func update(name: String) {
//        let baby = _baby.value
//        baby.name = name
//        try! baby.save()
//        self._baby.accept(baby)
//    }
//
//    func update(birthday: Date) {
//        let baby = _baby.value
//        baby.birthday = birthday
//        try! baby.save()
//        self._baby.accept(baby)
//    }
//
//    func update(theme: Theme) {
//        let baby = _baby.value
//        baby.theme = theme
//        try! baby.save()
//        self._baby.accept(baby)
//    }
//}
