//
//  MenuViewController.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2020/05/30.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let flux: Flux
    init(flux: Flux) {
        self.flux = flux
        super.init(nibName: "MenuViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        flux.mainAction.getTheme()
        tableView.rowHeight = 60
        tableView.backgroundView?.layer.opacity = 0
        tableView.layer.cornerRadius = 10
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flux.settingsStore.value.babies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let baby = self.flux.settingsStore.value.babies[indexPath.row]
        let baby = self.flux.settingsStore.value.babies[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = baby.name
        flux.mainAction.getTheme()
        //        let theme = Theme(rawValue: self.flux.mainStore.value.theme!)

        //        cell.contentView.backgroundColor = theme?.color
        cell.contentView.backgroundColor = baby.theme.color
        //        cell.contentView.layer.borderColor = theme?.color.cgColor
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.opacity = 0.7
        cell.contentView.layer.borderWidth = 3

        cell.contentView.layer.cornerRadius = 15
        cell.clipsToBounds = false
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.contentView.layer.shadowOpacity = 0.1
        cell.contentView.layer.shadowRadius = 5

        return cell
    }

    //赤ちゃんボタンタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _babyID = BabyID(rawValue: indexPath.row)
        guard let babyID = _babyID else { return }
        flux.mainAction.updateInitialBabyID(newInitialBabyID: babyID.rawValue)
        print("tapped ", babyID.rawValue)
        self.dismiss(animated: true, completion: nil)
    }

    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
