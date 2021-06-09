//
//  SettingsViewController.swift
//  HappyBabyNotes
//
//  Created by BadApple on 2019/06/10.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

// UIKitではViewだがMVVMではViewの扱い
final class SettingsViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var babyLabel: UILabel!

    // TableViewと自身をバインディング
    //  private let viewModel: SettingsViewModel
    private let dataSource: SettingsViewDataSource
    private let flux: Flux

    private let disposeBag = DisposeBag()

    init(flux: Flux) {
        self.flux = flux
        dataSource = SettingsViewDataSource(flux: flux)
        super.init(nibName: SettingsViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // dataSourceとDelegateを登録するなどする
        dataSource.configure(with: tableView)

        //　画面遷移
        self.flux.settingsStore.selectedSleepCell.subscribe(onNext: { e in

            guard e != nil else { return }

            let vc = SelectSleepUnitViewController(flux: self.flux)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)

        self.flux.settingsStore.selectedBabyCell.subscribe(onNext: { babyID in

            guard let babyID = babyID else { return }

            let vc = BabyNameViewController(flux: self.flux, babyID: babyID)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)

        self.flux.settingsStore.selectedBirthDayCell.subscribe(onNext: { babyID in

            guard let babyID = babyID else { return }
            //      Storyboardを指定
            let calendarStoryboard = UIStoryboard(name: "BC", bundle: nil)
            //       生成するViewControllerを指定
            let vc: BCViewController = calendarStoryboard.instantiateInitialViewController() as! BCViewController
            vc.babyID = babyID
            vc.flux = self.flux
            self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)

        self.flux.settingsStore.selectedThemeCell.subscribe(onNext: { babyID in

            guard let babyID = babyID else { return }

            let vc = ThemeCollerViewController(flux: self.flux, babyID: babyID)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)

        //    self.flux.settingsStore.selectedNewBabyCell.subscribe(onNext: { Baby in
        self.flux.settingsStore.selectedNewBabyCell.subscribe(onNext: { e in
            guard e != nil else { return }
            self.alertSet()

        }).disposed(by: disposeBag)

    }

    func alertSet() {
        let title = "赤ちゃんを追加しますか？"
        let okTitle = "はい"
        let noTitle = "いいえ"

        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        //no
        let cancelAction = UIAlertAction(title: noTitle, style: UIAlertAction.Style.default, handler: {
            // ボタンが押された時の処理を書く（クロージャ実装）
            (_: UIAlertAction!) -> Void in
            print("NO")
            self.flux.settingsAction.clearSlectedNewBaby()
        })

        // okボタン
        let defaultlAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.cancel, handler: {
            // ボタンが押された時の処理を書く（クロージャ実装）
            (_: UIAlertAction!) -> Void in
            print("OK")
            self.flux.settingsAction.addBaby()
            self.flux.settingsAction.clearSlectedNewBaby()
        })
        // UIAlertControllerにActionを追加
        alert.addAction(defaultlAction)
        alert.addAction(cancelAction)

        //  Alertを表示
        present(alert, animated: true, completion: nil)
    }
}
