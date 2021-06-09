//
//  ThemaCollerViewController.swift
//  HappyBabyNotes
//
//  Created by Au on 08/01/2020.
//  Copyright © 2020 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ThemeCollerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let flux: Flux
    let babyID: Int
    let disposeBag = DisposeBag()

    init(flux: Flux, babyID: Int) {
        self.flux = flux
        self.babyID = babyID
        super.init(nibName: "ThemeCollerViewController", bundle: nil)
    }

    deinit {
        self.flux.settingsAction.clearSlectedTheme()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        self.flux.settingsStore.babies.subscribe { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: self.disposeBag)

        // Do any additional setup after loading the view.
    }

    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    //セクション行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Theme.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = Theme(rawValue: indexPath.row)
        let cell = TableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = theme?.color

        if flux.settingsStore.value.babies.filter({ $0.id == babyID }).first?.theme == theme {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    // 各セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // 説明
            return "テーマカラーを変更することができます。"
        default:
            return nil
        }
    }

    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let _theme = Theme(rawValue: indexPath.row)
        guard let theme = _theme else { return }
        self.flux.settingsAction.update(BabyID: babyID, theme: theme)

    }

}

/*
 // MARK: - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
