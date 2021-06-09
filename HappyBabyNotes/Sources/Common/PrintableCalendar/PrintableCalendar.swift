//
//  HPBCalendar.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

public class PrintableCalendar {
    static let htmlFormatter = CalendarHTMLFormatter()

    public init() {
    }

    public func loadData() {
    }

    public func saveImage(from: Date, to: Date) {
        for date in Date.enumerateDates(from: from, to: to, increment: DateComponents.create {
            $0.day = 7
        }) {
            let weeklyRecord = try! (0...6).map {
                date.dateByAdding($0, .day)
            }.map {
                CommentAndDetails(date: $0,
                                  comment: try DailyRecord.get(babyID: 0, date: $0.date),
                                  details: try HourlyRecord.get(babyID: 0, date: $0.date)
                )
            }

            let html = PrintableCalendar.htmlFormatter.buildHTML(weeklyRecord: weeklyRecord)

            let renderer = HTMLRendererViewController(html: html)
            renderer.render()
        }
    }

    public func renderHTML() {
        let weeklyRecord = try! (0...6).map {
            DateInRegion(year: 2019, month: 5, day: 10).dateByAdding($0, .day)
        }.map {
            CommentAndDetails(date: $0,
                              comment: try DailyRecord.get(babyID: 0, date: $0.date),
                              details: try HourlyRecord.get(babyID: 0, date: $0.date)
            )
        }

        let html = PrintableCalendar.htmlFormatter.buildHTML(weeklyRecord: weeklyRecord)

        let renderer = HTMLRendererViewController(html: html)
        renderer.render()
    }
}
