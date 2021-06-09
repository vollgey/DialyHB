//
//  MainViewController.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/09.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 HeaderとFooterの操作をするファイル
 ***/

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import JTAppleCalendar

class MainViewController: UIViewController, UITabBarDelegate {

    var viewModel: MainViewModel!
    var notePageViewController: NotePageViewController!

    var flux: Flux!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var babyColllectionView: UICollectionView!
    @IBOutlet weak var todayLabel: UINavigationItem!
    @IBOutlet weak var mainTabbar: UITabBar!
    @IBOutlet var backView: UIView!
    //    var names = ["太郎", "二郎", "三郎"]

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        flux = Flux()
        viewModel = MainViewModel(flux: flux)
        //        setColor()
        self.flux.mainStore.getBabyID.subscribe { _ in
            print("reloadView")
            self.todayLabel.title = self.stringToday(date: self.flux.mainStore.value.mainDate!)
            self.loadView()

            self.flux.mainAction.getTheme()
            let theme = Theme(rawValue: self.flux.mainStore.value.theme!)
            self.mainTabbar.barTintColor = theme?.color.withAlphaComponent(0.15)
            self.navigationController?.navigationBar.barTintColor = theme?.color

            self.containerNotePage(flux: self.flux)
        }.disposed(by: self.disposeBag)

        self.flux.noteStore.date.subscribe { _ in
            print("reloadView", self.flux.mainStore.value.mainDate!)
            self.todayLabel.title = self.stringToday(date: self.flux.mainStore.value.mainDate!)
            self.containerNotePage(flux: self.flux)
        }.disposed(by: self.disposeBag)

        self.flux.mainStore.date.subscribe { _ in
            self.todayLabel.title = self.stringToday(date: self.flux.mainStore.value.mainDate!)
        }.disposed(by: disposeBag)

        self.flux.mainStore.updateInitialBabyID.subscribe { _ in
            self.loadView()
            self.containerNotePage(flux: self.flux)
        }.disposed(by: disposeBag)

        flux.settingsStore.selectedThemeCell.subscribe { _ in
            self.flux.mainAction.getTheme()
            let theme = Theme(rawValue: self.flux.mainStore.value.theme!)
            self.mainTabbar.barTintColor = theme?.color.withAlphaComponent(0.15)
            self.navigationController?.navigationBar.barTintColor = theme?.color
        }.disposed(by: disposeBag)

    }

    private var showSettings: Binder<Void> {
        Binder(self) { me, _ in
            let vc = SettingsViewController(flux: me.flux)
            me.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // notePageViewControllerをcontainerViewに設定
    func containerNotePage(flux: Flux) {
        notePageViewController = NotePageViewController(flux: flux)
        addChild(notePageViewController)
        notePageViewController.view.frame = containerView.bounds
        containerView.addSubview(notePageViewController.view)
        notePageViewController.didMove(toParent: self)
    }

    func stringToday(format: String = "yyyy年MM月dd日", date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: date)
    }

    func setColor() {
        self.flux.mainAction.getTheme()
        let theme = Theme(rawValue: self.flux.mainStore.value.theme!)
        UITabBar.appearance().backgroundColor = .gray
        todayLabel.rightBarButtonItem?.tintColor = theme?.color
        todayLabel.leftBarButtonItem?.tintColor = theme?.color
    }

    @IBAction func onSettingsButtonTapped(_ sender: Any) {
        let vc = SettingsViewController(flux: flux)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func handleBabyButton(_ sender: UIBarButtonItem) {
        flux.babyAction.getBabies()
        let vc = MenuViewController(flux: self.flux)
        present(vc, animated: true)
    }

    // 赤ちゃんの設定
    private func setBaby() {

    }

    // 今の時刻に飛ぶ関数
    private func onJumpNow() {
        notePageViewController.onJumpNow()
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        // Nowが押されたときの処理
        case 1:
            onJumpNow()
        // Jumpが押されたときの処理
        case 2:
            //            showAlertView(type: .calendar)
            //Storyboardを指定
            let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
            //生成するViewControllerを指定
            let vc: CalendarViewController = calendarStoryboard.instantiateInitialViewController() as! CalendarViewController
            vc.flux = flux
            //表示
            self.present(vc, animated: true, completion: nil)

        // Saveが押されたときの処理
        case 3:
            //            showAlertView(type: .save)
            //Storyboardを指定
            let calendarStoryboard = UIStoryboard(name: "SC", bundle: nil)
            //生成するViewControllerを指定
            let vc: SCViewController = calendarStoryboard.instantiateInitialViewController() as! SCViewController
            vc.flux = flux
            //表示
            self.present(vc, animated: true, completion: nil)
        default: break
        }
    }
}
