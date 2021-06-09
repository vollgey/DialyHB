//
// Created by BadApple on 2019-06-11.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftDate

class SettingsViewDataSource: NSObject {

    //    private let viewModel: SettingsViewModel
    let flux: Flux
    let disposeBag = DisposeBag()

    init(flux: Flux) {
        self.flux = flux
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self

        // cellの再構築
        self.flux.settingsStore.babies.subscribe {  _ in
            tableView.reloadData()
        }.disposed(by: self.disposeBag)

        self.flux.settingsStore.settings.subscribe {  _ in
            tableView.reloadData()
        }.disposed(by: self.disposeBag)

    }
}

extension SettingsViewDataSource: UITableViewDataSource {
    // セクションの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        flux.settingsStore.value.babies.count + 2
    }

    // 各セクションの行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1...flux.settingsStore.value.babies.count:
            return 3
        default:
            return 1
        }
    }

    // 各セルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // 共通設定
            switch indexPath.row {
            case 0:
                let cell = TableViewCell()
                cell.textLabel?.text = "24時制表示"
                cell.selectionStyle = .none
                cell.accessoryView = {
                    let sw = UISwitch()
                    sw.rx.isOn
                        .changed
                        .distinctUntilChanged()
                        .share(replay: 1, scope: .forever)
                        .subscribe(onNext: { isOn in
                            self.flux.settingsAction.update(isOn: isOn)
                        }).disposed(by: disposeBag)
                    sw.isOn = self.flux.settingsStore.value.settings!.is24HClockNotation
                    return sw
                }()
                return cell
            default:
                let cell = TableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = "睡眠の単位"
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = self.flux.settingsStore.value.settings?.sleepUnit.text
                return cell
            }
        case 1...flux.settingsStore.value.babies.count: // 各赤ちゃんの設定
            let baby = self.flux.settingsStore.value.babies[indexPath.section - 1]

            switch indexPath.row {
            case 0: // 名前
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = "名前"
                cell.detailTextLabel?.text = baby.name
                return cell
            case 1: // 誕生日
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = "誕生日"
                let formatter = DateFormatter()
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
                cell.detailTextLabel?.text = formatter.string(from: baby.birthday)
                //                cell.detailTextLabel?.text = baby.birthday.toString(.date(.full))
                return cell
            default: // 色
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = "テーマカラー"
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = baby.theme.text
                return cell
            }
        default: // 赤ちゃん追加ボタン
            let cell = UITableViewCell()
            cell.textLabel?.text = "赤ちゃんを追加..."
            cell.textLabel?.textColor = tableView.tintColor
            return cell
        }
    }

    // 各セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // 共通設定
            return "共通"
        case 1...flux.settingsStore.value.babies.count: // 各赤ちゃん（赤ちゃんの名前）
            return flux.settingsStore.value.babies[section - 1].name
        default: // 赤ちゃん追加ボタン
            return nil
        }
    }
}

extension SettingsViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0: // 共通設定
            switch indexPath.row {
            case 1: // 睡眠の単位
                self.flux.settingsAction.sleepCellTapped()

            default:
                break
            }
        case 1...flux.settingsStore.value.babies.count: // 各赤ちゃん（赤ちゃんの名前）
            switch indexPath.row {
            case 0: //赤ちゃんの名前
                self.flux.settingsAction.babyCellTapped(BabyID: flux.settingsStore.value.babies[indexPath.section - 1].id)

            case 1: //誕生日
                self.flux.settingsAction.birthDayCellTapped(BabyID: flux.settingsStore.value.babies[indexPath.section - 1].id)

            case 2: //テーマカラー
                self.flux.settingsAction.themeCellTapped(BabyID: flux.settingsStore.value.babies[indexPath.section - 1].id)
            default:
                break
            }
        default: // 赤ちゃん追加ボタン
            self.flux.settingsAction.newBabyCellTapped()
        }

    }
}
