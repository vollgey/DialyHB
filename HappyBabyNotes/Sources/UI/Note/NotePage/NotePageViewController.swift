//
//  PageViewController.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 前の日と次の日のページを用意するファイル.
 ***/

import Foundation
import UIKit
import SwiftDate
import RxSwift
import RxCocoa
import RxRelay

class NotePageViewController: UIPageViewController {

    private var appearVC: NoteViewController!

    let flux: Flux
    var date: Date

    let disposeBag = DisposeBag()

    init(flux: Flux) {
        print("NotePageVC initialized", flux.mainStore.value.babyID!, flux.noteStore.value.noteDate!)

        self.flux = flux
        self.date = flux.noteStore.value.noteDate!
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        appearVC = NoteViewController(flux: self.flux, date: self.date)
        appearVC.number = 0

        //        beforeVC = NoteViewController(settings: viewModel.settings, date: viewModel.date - 1.days)

        //        afterVC = NoteViewController(settings: viewModel.settings, date: viewModel.date + 1.days)

        setViewControllers([appearVC], direction: .forward, animated: true, completion: nil)

        // 両端タップで遷移を無効化
        view.gestureRecognizers?.filter { $0 is UITapGestureRecognizer }.first?.isEnabled = false

        //        viewModel.output.date.map { $0.toString(.date(.full)) }
        //                .drive(rx.title)
        //                .disposed(by: disposeBag)

        //        parent?.navigationItem.title = viewModel.dateValue.toString(.date(.full))
        //        viewModel.output.date.drive(setTitle).disposed(by: disposeBag)

    }

    func onJumpNow() {
        appearVC.onJumpNow()
    }
    var mainDate = Date()
    func getBefore() -> NoteViewController {
        let beforeDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        mainDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        return NoteViewController(flux: flux, date: beforeDate)
    }
    func getAfter() -> NoteViewController {
        let afterDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        mainDate = afterDate
        return NoteViewController(flux: flux, date: afterDate)
    }

}

extension NotePageViewController: UIPageViewControllerDataSource {
    // 前のPageのViewControllerを指定する
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if !appearVC.isLoaded {
            return nil
        }
        appearVC = getBefore()
        appearVC.number = (viewController as! NoteViewController).number - 1
        return appearVC
    }

    // 次のPageのViewControllerを指定する
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if !appearVC.isLoaded {
            return nil
        }
        appearVC = getAfter()
        appearVC.number = (viewController as! NoteViewController).number + 1
        return appearVC
    }
}

extension NotePageViewController: UIPageViewControllerDelegate {
    // ページ遷移中に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        flux.mainAction.updateDate(by: mainDate)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        flux.noteAction.updateDate(by: mainDate)
    }
}
