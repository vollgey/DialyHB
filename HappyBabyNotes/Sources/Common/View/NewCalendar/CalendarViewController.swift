//
//  CalendarViewController.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2019/11/29.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa
import RxRelay
import SwiftDate

class CalendarViewController: UIViewController {
    var flux: Flux! = nil

    @IBOutlet var calendarBackView: UIView!
    //    @IBOutlet weak var calendarNavigation: UINavigationBar!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var monthTitle: UILabel!
    @IBOutlet weak var monthView: UIView!

    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!

    let yearList = ["0", "1", "2", "3", "4", "5"]
    let monthList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

    let calendar = Calendar(identifier: .gregorian)
    let formatter = DateFormatter()
    private let disposeBag = DisposeBag()

    var currentMonthSymbol: String {
        get {
            let startDate = (calendarView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month - 1]
            return monthString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        //        showTodayWithAnimate()
        calendarView.scrollToDate(flux.noteStore.value.noteDate!)

        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        monthPickerView.dataSource = self
        monthPickerView.delegate = self

        let elapsedComps = calendar.dateComponents([.year, .month, .day], from: flux.settingsStore.value.babies[flux.mainStore.value.babyID!].birthday, to: flux.noteStore.value.noteDate!)
        yearPickerView.selectRow(elapsedComps.year!, inComponent: 0, animated: true)
        monthPickerView.selectRow(elapsedComps.month!, inComponent: 0, animated: true)

        flux.settingsStore.selectedThemeCell.subscribe { _ in
            self.flux.mainAction.getTheme()
            let theme = Theme(rawValue: self.flux.mainStore.value.theme!)
            //            self.calendarNavigation.barTintColor = theme?.color
            //            self.calendarBackView.backgroundColor = theme?.color
            self.monthView.backgroundColor = theme?.color.withAlphaComponent(0.6)
        }.disposed(by: disposeBag)
    }
    //todayButton押したときの処理
    @IBAction func showTodayButton(_ sender: Any) {
        showTodayWithAnimate()
    }
    // 前の月ボタン
    @IBAction func prevMonthButton(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
    // 次の月ボタン
    @IBAction func nextMonthButton(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }

    //cellの中身
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    //今日を表示
    func showTodayWithAnimate() {
        showToday(animate: true)
    }

    func showToday(animate: Bool) {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.calendarView.visibleDates { [unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            self.calendarView.selectDates([Date()])
        }
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let year = Calendar.current.component(.year, from: startDate)
        title = "\(year) \(currentMonthSymbol)"
    }
    //    cellの中身
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell else {
            return
        }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        guard let myCustomCell = view as? DateCell else { return }
        myCustomCell.dateLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        myCustomCell.isHidden = cellHidden
        myCustomCell.selectedView.backgroundColor = UIColor.lightGray
        if Calendar.current.isDateInToday(cellState.date) {
            myCustomCell.selectedView.backgroundColor = UIColor.pink
        }
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    //cellを選択すると
    func handleCellSelection(view: DateCell, cellState: CellState) {
        view.selectedView.isHidden = !cellState.isSelected
    }

    func handleCellTextColor(view: DateCell, cellState: CellState) {
        if cellState.isSelected {
            view.dateLabel.textColor = UIColor.lightBlue
        } else {
            view.dateLabel.textColor = UIColor.black
            if cellState.day == .sunday || cellState.day == .saturday {
                view.dateLabel.textColor = UIColor.gray
            }
        }
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                view.dateLabel.textColor = UIColor.lightBlue
            } else {
                view.dateLabel.textColor = UIColor.red
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2010 01 01")!
        let endDate = Date()

        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    //    cellを表示しするとき
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath)as! DateCell
        cell.selectedView.isHidden = false
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)

        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5

        return cell
    }

    //cellをタップした時
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        self.dismiss(animated: true, completion: nil)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!

        flux.mainAction.updateDate(by: modifiedDate)
        flux.noteAction.updateDate(by: modifiedDate)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy年M月"
        monthTitle.text = formatter.string(from: date)
    }
}

extension CalendarViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearPickerView:
            return yearList.count

        case monthPickerView:
            return monthList.count

        default:
            fatalError()
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case yearPickerView:
            return yearList[row]

        case monthPickerView:
            return monthList[row]

        default:
            fatalError()
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let baby = self.flux.settingsStore.value.babies[flux.mainStore.value.babyID!]
        let birthday = baby.birthday

        switch pickerView {

        case yearPickerView:

            var modifiedDate: Date = Calendar.current.date(byAdding: .year, value: Int(yearList[row])!, to: birthday) ?? Date()
            modifiedDate = Calendar.current.date(byAdding: .month, value: Int(monthPickerView.selectedRow(inComponent: 0)), to: modifiedDate) ?? Date()

            calendarView.scrollToDate(modifiedDate)
            print("yearPickerView Selected !!!")
            print(modifiedDate)

        case monthPickerView:

            var modifiedDate: Date = Calendar.current.date(byAdding: .month, value: Int(monthList[row])!, to: birthday) ?? Date()
            modifiedDate = Calendar.current.date(byAdding: .year, value: Int(yearPickerView.selectedRow(inComponent: 0)), to: modifiedDate) ?? Date()
            calendarView.scrollToDate(modifiedDate)
            print("monthPickerView Selected !!!")
            print(modifiedDate)

        default:
            fatalError()
        }
    }

}
