//
//  SleepUnitViewController.swift
//  HappyBabyNotes
//
//  Created by Au on 04/12/2019.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SelectSleepUnitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    let flux: Flux

    let disposeBag = DisposeBag()
    init(flux: Flux) {
        self.flux = flux
        super.init(nibName: "SleepUnitViewController", bundle: nil)
    }

    deinit {
        self.flux.settingsAction.clearSelectedSleep()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        self.flux.settingsStore.settings.subscribe { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: self.disposeBag)

    }

    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    //セクション行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SleepUnit.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TableViewCell(style: .value1, reuseIdentifier: nil)
        let sleepUnitText = SleepUnit(rawValue: indexPath.row)
        cell.textLabel?.text = sleepUnitText?.text

        //　チェックマーク
        if flux.settingsStore.value.settings?.sleepUnit == sleepUnitText {
            cell.accessoryType = .checkmark
        }

        return cell

    }

    // 各セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // 説明
            return "睡眠時間単位の設定を変更することができます。"
        default:
            return nil
        }
    }

    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let _sleepUnit = SleepUnit(rawValue: indexPath.row)
        guard let sleepUnit = _sleepUnit else { return }
        self.flux.settingsAction.update(sleepUnit: sleepUnit)

    }

}
