//
//  NoteViewModel.swift
//  HappyBabyNotes
//
//  Created by BadApple on 2019/06/18.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxCocoa
import RxRelay

class NoteViewModel {
    let output: Output

    let flux: Flux

    let disposeBag = DisposeBag()

    init(flux: Flux) {
        self.flux = flux

        output = Output(
            comment: flux.noteStore.comment.asDriver(onErrorDriveWith: Driver.empty())
        )
    }
}

extension NoteViewModel {
    struct Output {
        let comment: Driver<String?>
    }
}
