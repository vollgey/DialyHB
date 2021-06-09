//
// Created by BadApple on 2019-05-10.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import SQLite

enum Database {
    static let conn: Connection = {
        SQLite.dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }()

        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = dir.appendingPathComponent("HappyBaby.db")
        #if DEBUG
        print(filePath)
        #endif
        let path = filePath.absoluteString

        let conn = try! Connection(path)

        #if DEBUG
        conn.trace {
            print($0)
        }
        #endif

        return conn
    }()

    static func createTables(ifNotExists: Bool = true) {
        try! DailyRecord.createTable(ifNotExists: ifNotExists)
        try! HourlyRecord.createTable(ifNotExists: ifNotExists)
        try! Baby.createTable(ifNotExists: ifNotExists)
        try! Settings.createTable(ifNotExists: ifNotExists)

        let d = Date(year: 2020, month: 1, day: 15, hour: 0, minute: 0)

        try! DailyRecord(
            babyID: 0,
            date: d,
            comment: "hogehoge"
        ).insert(or: .ignore)

        try! HourlyRecord(manNumber: 0, date: d, hour: 0, sleep: .after, milk: .food, diaper: .booBoo, memo: "memomemo").insert(or: .ignore)
    }
}
