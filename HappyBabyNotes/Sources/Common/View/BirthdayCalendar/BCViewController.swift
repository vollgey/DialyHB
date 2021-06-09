//
//  BCViewController.swift
//  HappyBabyNotes
//
//  Created by Tomokawa Takumi on 2020/03/05.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa
import RxRelay

class BCViewController: UIViewController {
    var flux: Flux! = nil
    private let disposeBag = DisposeBag()
    let formatter = DateFormatter()
    var babyID = 0

    @IBOutlet weak var bCView: JTAppleCalendarView!
    @IBOutlet weak var monthTitle: UILabel!

    var currentMonthSymbol: String {
        get {
            let startDate = (bCView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month - 1]
            return monthString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bCView.scrollDirection = .horizontal
        bCView.scrollingMode = .stopAtEachCalendarFrame
        bCView.showsHorizontalScrollIndicator = false
        //        showTodayWithAnimate()
        bCView.scrollToDate(Date())
    }

    deinit {
        self.flux.settingsAction.clearSelectedBirthDay()
    }

    @IBAction func prevYearButton(_ sender: Any) {
        for _ in 1..<7 {
            bCView.scrollToSegment(.previous)
        }
    }

    @IBAction func nextYearButton(_ sender: Any) {
        for _ in 1..<7 {
            bCView.scrollToSegment(.next)
        }
    }

    //今日を表示
    func showTodayWithAnimate() {
        showToday(animate: true)
    }

    func showToday(animate: Bool) {
        bCView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.bCView.visibleDates { [unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            self.bCView.selectDates([Date()])
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
        guard let cell = view as? BCDateCell else {
            return
        }
        cell.bCDateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        guard let myCustomCell = view as? BCDateCell else { return }
        myCustomCell.bCDateLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        myCustomCell.isHidden = cellHidden
        myCustomCell.bCSelectedView.backgroundColor = UIColor.lightGray
        if Calendar.current.isDateInToday(cellState.date) {
            myCustomCell.bCSelectedView.backgroundColor = UIColor.red
        }
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }

    //cellを選択すると
    func handleCellSelection(view: BCDateCell, cellState: CellState) {
        view.bCSelectedView.isHidden = !cellState.isSelected
    }

    func handleCellTextColor(view: BCDateCell, cellState: CellState) {
        if cellState.isSelected {
            view.bCDateLabel.textColor = UIColor.blue
        } else {
            view.bCDateLabel.textColor = UIColor.black
            if cellState.day == .sunday || cellState.day == .saturday {
                view.bCDateLabel.textColor = UIColor.gray
            }
        }
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                view.bCDateLabel.textColor = UIColor.blue
            } else {
                view.bCDateLabel.textColor = UIColor.red
            }
        }
    }

    func handleCellTextColor(cell: BCDateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.bCDateLabel.textColor = UIColor.black
        } else {
            cell.bCDateLabel.textColor = UIColor.gray
        }
    }

}

extension BCViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2010 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension BCViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "bCDateCell", for: indexPath) as! BCDateCell
        cell.bCSelectedView.isHidden = false
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    //    cellを表示しするとき
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    //cellをタップした時
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        self.dismiss(animated: true, completion: nil)
        self.flux.settingsAction.update(BabyID: babyID, birthday: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy年MM月"
        monthTitle.text = formatter.string(from: date)
    }
}
