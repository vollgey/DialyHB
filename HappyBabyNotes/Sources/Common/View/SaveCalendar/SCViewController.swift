//
//  SCViewController.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2020/03/25.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa
import RxRelay
import SwiftDate

class SCViewController: UIViewController {
    var flux: Flux! = nil
    private let disposeBag = DisposeBag()
    let formatter = DateFormatter()
    var babyID = 0
    var firstDate: Date?
    var lastDate: Date?

    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthTitle: UILabel!
    @IBOutlet weak var sCView: JTAppleCalendarView!

    var currentMonthSymbol: String {
        get {
            let startDate = (sCView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month - 1]
            return monthString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sCView.scrollDirection = .horizontal
        sCView.scrollingMode = .stopAtEachCalendarFrame
        sCView.showsHorizontalScrollIndicator = false
        sCView.scrollToDate(Date())
        sCView.allowsMultipleSelection = true
        sCView.isRangeSelectionUsed = true

        flux.settingsStore.selectedThemeCell.subscribe { _ in
            self.flux.mainAction.getTheme()
            let theme = Theme(rawValue: self.flux.mainStore.value.theme!)
            //            self.calendarNavigation.barTintColor = theme?.color
            //            self.calendarBackView.backgroundColor = theme?.color
            self.monthView.backgroundColor = theme?.color.withAlphaComponent(0.6)
        }.disposed(by: disposeBag)
    }

    @IBAction func saveButton(_ sender: Any) {

        let printableCalendar = PrintableCalendar()
        //        let firstDateInRegion = DateInRegion(self.flux.noteStore.value.firstDate!, region: Region.current)
        //        let lastDateInRegion = DateInRegion(self.flux.noteStore.value.lastDate!, region: Region.current)
        printableCalendar.saveImage(from: flux.noteStore.value.firstDate!, to: flux.noteStore.value.lastDate!)
        self.dismiss(animated: true, completion: nil)
    }

    //    cell操作の中身
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        let theme = Theme(rawValue: self.flux.mainStore.value.theme!)

        guard let cell = view as? SCDateCell else { return }
        handleCellTextColor(cell: cell, cellState: cellState)

        guard let myCustomCell = view as? SCDateCell else { return }
        myCustomCell.sCDateLabel.text = cellState.text

        let cellHidden = cellState.dateBelongsTo != .thisMonth
        myCustomCell.isHidden = cellHidden
        myCustomCell.sCSelectedView.backgroundColor = theme?.color.withAlphaComponent(0.6)

        if Calendar.current.isDateInToday(cellState.date) {
            myCustomCell.sCSelectedView.backgroundColor = UIColor.red
        }

        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }

    //cellを選択すると
    func handleCellSelection(view: SCDateCell, cellState: CellState) {
        view.sCSelectedView.isHidden = !cellState.isSelected
    }

    func handleCellTextColor(view: SCDateCell, cellState: CellState) {
        if cellState.isSelected {
            view.sCDateLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        } else {
            view.sCDateLabel.textColor = UIColor.black
            if cellState.day == .sunday || cellState.day == .saturday {
                view.sCDateLabel.textColor = UIColor.gray
            }
        }
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                view.sCDateLabel.textColor = UIColor.blue
            } else {
                view.sCDateLabel.textColor = UIColor.red
            }
        }
    }

    func handleCellTextColor(cell: SCDateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.sCDateLabel.textColor = UIColor.black
        } else {
            cell.sCDateLabel.textColor = UIColor.gray
        }
    }
}

extension SCViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2010 01 01")!
        let endDate = Date()

        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }

}

extension SCViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "sCDateCell", for: indexPath) as! SCDateCell
        cell.sCSelectedView.isHidden = false
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)

        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5

        return cell
    }

    //    cellを表示しするとき
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    //cellをタップした時
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        //        if firstDate != nil {
        //            if date < self.firstDate! {
        //                self.firstDate = date
        //            } else {
        //                self.lastDate = date
        //            }
        //            sCView.selectDates(from: firstDate!, to: self.lastDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        //        } else {
        //            self.firstDate = date
        //            self.lastDate = date
        //        }

        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        if firstDate != nil {
            if modifiedDate < self.firstDate! || self.lastDate! < modifiedDate {
                let beforeFirstDate = Calendar.current.date(byAdding: .day, value: -1, to: self.firstDate!)!
                sCView.deselectDates(from: beforeFirstDate, to: self.lastDate!, triggerSelectionDelegate: false)
                self.firstDate = modifiedDate
                self.lastDate = Calendar.current.date(byAdding: .day, value: 5, to: modifiedDate)!
                sCView.selectDates(from: firstDate!, to: self.lastDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
        } else {
            self.firstDate = modifiedDate
            self.lastDate = Calendar.current.date(byAdding: .day, value: 5, to: modifiedDate)!
            sCView.selectDates(from: firstDate!, to: self.lastDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        }

        self.flux.noteAction.updateFirstDate(date: firstDate!)
        self.flux.noteAction.updateLastDate(date: lastDate!)

        //        self.dismiss(animated: true, completion: nil)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.firstDate!)!
        sCView.deselectDates(from: modifiedDate, to: self.lastDate!, triggerSelectionDelegate: false)
        self.firstDate = nil
        self.lastDate = nil
        //        if date != self.firstDate && date != self.lastDate {
        //            if date < self.firstDate! {
        //                self.firstDate = date
        //            } else {
        //                self.lastDate = date
        //            }
        //            sCView.selectDates(from: firstDate!, to: self.lastDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        //        } else {
        //            self.firstDate = nil
        //            self.lastDate = nil
        //        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy年MM月"
        monthTitle.text = formatter.string(from: date)
    }

}
