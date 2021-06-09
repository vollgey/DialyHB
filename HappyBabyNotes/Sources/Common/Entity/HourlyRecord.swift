//
//  DiaryDataDetail.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SQLite

struct HourlyRecord {

    private static let table = Table("DailyDataDetail")
    var manNumber: Int
    var date: Date
    var hour: Int
    var sleep: Sleep?
    var milk: Milk?
    var diaper: Diaper?
    var memo: String?

    private(set) var created: Bool

    enum Keys {
        case manNumber
        case date
        case hour
        case sleep
        case milk
        case diaper
        case memo
    }

    enum Columns {
        static let manNumber = Expression<Int>("ManNumber")//キー
        static let date = Expression<Date>("Date")//キー
        static let hour = Expression<Int>("Hour")//キー
        static let sleep = Expression<Int?>("Sleep")//0:空白 1~13:睡眠時間
        static let milk = Expression<Int?>("Milk")//null or 0:null 1~6:母乳・粉ミルク・離乳食
        static let milkVol = Expression<Int?>("MilkVol")//ミルクの量
        static let diaper = Expression<Int?>("Omutsu")//null or 0:null 1:尿 2:便 3:尿＆便
        static let memo = Expression<String?>("Memo")//日記
        static let exp1 = Expression<String?>("Exp1")//予備１
        static let exp2 = Expression<String?>("Exp2")//予備２
        static let exp3 = Expression<String?>("Exp3")//予備３
    }

    init(manNumber: Int, date: Date, hour: Int, sleep: Sleep? = nil, milk: Milk? = nil, diaper: Diaper? = nil, memo: String? = nil) {
        self.manNumber = manNumber
        self.date = date
        self.hour = hour
        self.sleep = sleep
        self.milk = milk
        self.diaper = diaper
        self.memo = memo

        created = false
    }

    init(row: Row) {
        self.manNumber = row[Columns.manNumber]
        self.date = row[Columns.date]
        self.hour = row[Columns.hour]
        self.sleep = row[Columns.sleep].flatMap { Sleep(rawValue: $0 - 1) }
        self.milk = row[Columns.milk].flatMap { Milk(rawValue: $0 - 1) }
        self.diaper = row[Columns.diaper].flatMap { Diaper(rawValue: $0 - 1) }
        self.memo = row[Columns.memo]

        created = true
    }

    static func createTable(ifNotExists: Bool = true) throws {
        try Database.conn.run(table.create(ifNotExists: ifNotExists) { t in
            t.column(Columns.manNumber)
            t.column(Columns.date)
            t.column(Columns.hour)
            t.column(Columns.sleep)
            t.column(Columns.milk)
            t.column(Columns.milkVol)
            t.column(Columns.diaper)
            t.column(Columns.memo)
            t.column(Columns.exp1)
            t.column(Columns.exp2)
            t.column(Columns.exp3)
            t.primaryKey(Columns.manNumber, Columns.date, Columns.hour)
        })
    }

    func insert(or: OnConflict = .fail) throws {
        try Database.conn.run(HourlyRecord.table.insert(or: or,
                                                        Columns.manNumber <- manNumber,
                                                        Columns.date <- date,
                                                        Columns.hour <- hour,
                                                        Columns.sleep <- sleep.map { $0.rawValue + 1 },
                                                        Columns.milk <- milk.map { $0.rawValue + 1 },
                                                        Columns.diaper <- diaper.map { $0.rawValue + 1 },
                                                        Columns.memo <- memo
        ))
    }

    static func get(babyID: Int, date: Date) throws -> [HourlyRecord] {
        try Database.conn.prepare(table
                                    .filter(Columns.manNumber == babyID &&
                                                Columns.date == date)
                                    .order(Columns.hour)
        ).map(HourlyRecord.init(row:))
    }

    mutating func setCreated() {
        created = true
    }

    mutating func save(_ keys: Keys...) throws {
        if created {
            try Database.conn.run(HourlyRecord.table
                                    .filter(Columns.manNumber == manNumber &&
                                                Columns.date == date &&
                                                Columns.hour == hour)
                                    .update(keys.map {
                                        switch $0 {
                                        case .manNumber:
                                            return Columns.manNumber <- manNumber
                                        case .date:
                                            return Columns.date <- date
                                        case .hour:
                                            return Columns.hour <- hour
                                        case .sleep:
                                            return Columns.sleep <- sleep.map { $0.rawValue + 1 }
                                        case .milk:
                                            return Columns.milk <- milk.map { $0.rawValue + 1 }
                                        case .diaper:
                                            return Columns.diaper <- diaper.map { $0.rawValue + 1 }
                                        case .memo:
                                            return Columns.memo <- memo
                                        }
                                    })
            )
        } else {
            try insert()
        }
    }
}

extension HourlyRecord: Equatable {
    public static func ==(lhs: HourlyRecord, rhs: HourlyRecord) -> Bool {
        lhs.hour == rhs.hour && lhs.date == rhs.date
    }
}
