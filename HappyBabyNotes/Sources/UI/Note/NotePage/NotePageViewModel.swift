////
//// Created by BadApple on 2019-06-24.
//// Copyright (c) 2019 Studio9. All rights reserved.
////
//
//import Foundation
//import SwiftDate
//import RxSwift
//import RxCocoa
//import RxRelay
//
//class NotePageViewModel {
//    let flux: Flux
//    let output: Output
//
//    init(flux: Flux) {
//        self.flux = flux
//        flux.noteAction.getHourlyRecords(babyID: 0, date: Date())
//
//        output = Output(
//                date: flux.noteStore.date.asDriver(onErrorDriveWith: Driver.empty())
//        )
//    }
//
//    func before() {
////        transitionDirection = .Left
//    }
//
//    func after() {
////        transitionDirection = .Right
//    }
//
//    func transitionCompleted() {
////        let actions = flux.noteAction
//
////        guard let _transitionDirection = transitionDirection else { return }
////        switch _transitionDirection {
////        case .Left:
////            actions.nextPage()
////        case .Right:
////            actions.nextPage()
////        }
//    }
//}
//
//extension NotePageViewModel {
//    struct Output {
//        let date: Driver<Date>
//    }
//
//    enum Direction {
//        case Left
//        case Right
//    }
//}
