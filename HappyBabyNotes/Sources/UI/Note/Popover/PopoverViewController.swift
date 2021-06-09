//
//  PopoverViewController.swift
//  HappyBabyNotes
//
//  Created by Au on 02/04/2020.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    let flux: Flux
    let type: PopoverType
    let record: HourlyRecord

    init(flux: Flux, type: PopoverType, record: HourlyRecord) {
        self.flux = flux
        self.type = type
        self.record = record
        super.init(nibName: PopoverViewController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        flux.noteAction.clearLongTap()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let hour = String(record.hour)

        switch type {
        case .sleep:
            timeLabel.text = hour + "時" + " " + "sleep"
        case .milk:
            timeLabel.text = hour + "時" + " " + "milk"
        case .diaper:
            timeLabel.text = hour + "時" + " " + "diaper"
        }

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
