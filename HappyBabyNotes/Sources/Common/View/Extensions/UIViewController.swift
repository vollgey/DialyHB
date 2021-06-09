//
//  UIViewController.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

/***
 AlertViewを操作するファイル.
 ***/

import UIKit

extension UIViewController {

    func showAlertView(type: AlertType) {
        switch type {
        // SetDateViewの表示
        case .setDate:
            guard let view = UINib(nibName: AlertType.setDate.rawValue, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
            view.frame = self.view.bounds
            self.view.addSubview(view)
        // SettingViewの表示
        case .setting:
            guard let view = UINib(nibName: AlertType.setting.rawValue, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
            view.frame = self.view.bounds
            self.view.addSubview(view)
        // SaveViewの表示
        case .save:
            guard let view = UINib(nibName: AlertType.save.rawValue, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
            view.frame = self.view.bounds
            self.view.addSubview(view)
        // SetDateViewの表示
        case .calendar:
            //Storyboardを指定
            let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
            //生成するViewControllerを指定
            let vc: CalendarViewController = calendarStoryboard.instantiateInitialViewController() as! CalendarViewController

            //表示
            self.present(vc, animated: true, completion: nil)

        //            //Storyboardを指定
        //            let  sCalendarStoryboard: UIStoryboard = UIStoryboard(name: "SC", bundle: nil)
        //            //生成するViewControllerを指定
        //            let vc: SCViewController = sCalendarStoryboard.instantiateInitialViewController() as! SCViewController
        //            //表示
        //            self.present(vc, animated: true, completion: nil)
        }
    }
}

//extension NoteViewController: UIPopoverPresentationControllerDelegate {
//    func showPopoverView(type: PopoverType) {
//        //Prepare the instance of ContentViewController which is the content of popover.
//        let vc = PopoverViewController(flux: self.flux, type: type)
//        //define use of popover
//        vc.modalPresentationStyle = .popover
//        //set size
//        vc.preferredContentSize = CGSize(width: 300, height: 300)
//        //set origin
//        vc.popoverPresentationController?.sourceView = view
//        vc.popoverPresentationController?.sourceRect = view.frame
//        //set arrow direction
//        vc.popoverPresentationController?.permittedArrowDirections = .any
//        //set delegate
//        vc.popoverPresentationController?.delegate = self
//        //present
//        present(vc, animated: true, completion: nil)
//    }
//
//    /// Popover appears on iPhone
//    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        .none
//    }
//
//}
