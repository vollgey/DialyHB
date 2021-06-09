//
//  CalendarHTMLFormatter.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

import SwiftDate
import Foundation

public class CalendarHTMLFormatter {
    private func createRow(hour: Int, sleep: String, milk: String, diaper: String, memo: String) -> String {
        """
        <tr>
        <td class="time">\(hour)</td>
        <td class="sleep"><img src="\(sleep)"></td>
        <td class="milk"><img src="\(milk)"></td>
        <td class="diaper"><img src="\(diaper)"></td>
        <td class="memo"><a>\(memo)</a></td>
        </tr>
        """
    }

    private func buildRow(hour: Int, detail d: HourlyRecord) -> String {
        createRow(hour: hour, sleep: d.sleep?.path ?? "", milk: d.milk?.path ?? "",
                  diaper: d.diaper?.path ?? "", memo: d.memo ?? "")
    }

    private func createTotalRow(hour: Int, min: Int, milkCount: Int, urineCount: Int, excrementCount: Int) -> String {
        """
        <tr class="total">
        <td class="time rotate45"><a>TOTAL</a></td>
        <td class="sleep">
        <a>\(hour)h</a><br>
        <a>\(min)m</a>
        </td>
        <td class="milk">\(milkCount)</td>
        <td class="diaper">
        <img src="urine.png">\(urineCount)<br>
        <img src="excrement.png">\(excrementCount)<br>
        </td>
        <td class="memo"></td>
        </tr>
        """
    }

    private func buildRows(details: [HourlyRecord]) -> String {
        var rows = ""

        for i in 0...24 {
            if let detail = details.filter({ $0.hour == i }).first {
                rows.append(buildRow(hour: i, detail: detail))
            } else {
                rows.append(createRow(hour: i, sleep: "", milk: "", diaper: "", memo: ""))
            }
        }

        return rows
    }

    private func createOneDayTable(headerDate: String, rows: String, totalRow: String, comment: String) -> String {
        """
        <div class"one-day">
        <div class="header">\(headerDate)</div>
        <table>
        \(rows)
        \(totalRow)
        </table>
        <div class="comment">\(comment)</div>
        </div>
        """
    }

    private func buildDailyColumn(commentAndDetails: CommentAndDetails) -> String {
        let rows = buildRows(details: commentAndDetails.details)

        let time = calcTime(details: commentAndDetails.details)
        let milkCount = milkCounter(details: commentAndDetails.details)
        let diaperCount = diaperCounter(details: commentAndDetails.details)

        let totalRow = createTotalRow(hour: time.hour, min: time.min, milkCount: milkCount, urineCount: diaperCount.urine, excrementCount: diaperCount.excrement)

        return createOneDayTable(headerDate: commentAndDetails.date.toString(.date(.full)),
                                 rows: rows, totalRow: totalRow, comment: commentAndDetails.comment?.comment ?? "")
    }

    private func buildCalendar(weeklyRecord: [CommentAndDetails]) -> String {
        var calendar = ""

        for commentAndDetails in weeklyRecord {
            calendar.append(buildDailyColumn(commentAndDetails: commentAndDetails))
        }

        return calendar
    }

    private func createHTML(calendar: String) -> String {
        """
        <!DOCTYPE html>
        <html lang="ja">

        <head>
        <meta charset="UTF-8">
        <title>Calendar</title>
        <link rel="stylesheet" type="text/css" href="style.css">
        </head>

        <body>
        <div class="calendar">
        \(calendar)
        </div>
        </body>

        </html>
        """
    }

    private func calcTime(details: [HourlyRecord]) -> (hour: Int, min: Int) {
        var hour = 0
        var min = 0

        for i in 0...24 {
            if let detail = details.filter({ $0.hour == i }).first {
                if let sleepTime = detail.sleep?.rawValue {
                    switch sleepTime {
                    case 0, 2, 7, 12:
                        min += 30
                    case 3, 5, 8:
                        min += 15
                    case 4, 6, 9, 10, 11:
                        min += 45
                    case 1:
                        min += 60
                    default:
                        min += 0
                    }
                }
            } else {
                hour += 0
                min += 0
            }
        }

        return (min / 60, min % 60)
    }

    private func milkCounter(details: [HourlyRecord]) -> Int {
        var milkCount = 0

        for i in 0...24 {
            if let detail = details.filter({ $0.hour == i }).first {
                if let m = detail.milk?.rawValue {
                    switch m {
                    case 0, 1, 2, 3, 4, 5:
                        milkCount += 1
                    default:
                        milkCount += 0
                    }
                }
            } else {
                milkCount += 0
            }
        }
        return milkCount
    }

    private func diaperCounter(details: [HourlyRecord]) -> (urine: Int, excrement: Int) {
        var urineCount = 0
        var excrementCount = 0

        for i in 0...24 {
            if let detail = details.filter({ $0.hour == i }).first {
                if let d = detail.diaper?.rawValue {
                    switch d {
                    case 0:
                        excrementCount += 1
                    case 1:
                        urineCount += 1
                    case 2:
                        excrementCount += 1
                        urineCount += 1
                    default:
                        excrementCount += 0
                        urineCount += 0
                    }
                }
            } else {
                excrementCount += 0
                urineCount += 0
            }
        }
        return (urineCount, excrementCount)
    }
    public func buildHTML(weeklyRecord: [CommentAndDetails]) -> String {

        let calendar = buildCalendar(weeklyRecord: weeklyRecord)

        return createHTML(calendar: calendar)
    }
}
