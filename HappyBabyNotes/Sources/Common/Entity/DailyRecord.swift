//
//  DailyData.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SQLite

final class DailyRecord {

    static let table = Table("DailyData")
    private(set) var babyID: Int
    var date: Date
    var comment: String?

    enum Keys {
        case manNumber
        case date
        case comment
    }

    private(set) var updatedKeys: Set<Keys> = []
    private(set) var created: Bool

    enum Columns {
        static let babyID = Expression<Int>("ManNumber")//キー
        static let date = Expression<Date>("Date")//キー
        static let comment = Expression<String?>("Comment")//日記
        static let exp1 = Expression<String?>("Exp1")//予備1
        static let exp2 = Expression<String?>("Exp2")//予備2
        static let exp3 = Expression<String?>("Exp3")//予備3
    }

    init(babyID: Int, date: Date, comment: String) {
        self.babyID = babyID
        self.date = date
        self.comment = comment

        created = false
    }

    init(row: Row) {
        self.babyID = row[Columns.babyID]
        self.date = row[Columns.date]
        self.comment = row[Columns.comment]

        created = true
    }

    class func createTable(ifNotExists: Bool = true) throws {
        try Database.conn.run(table.create(ifNotExists: ifNotExists) { t in
            t.column(Columns.babyID)
            t.column(Columns.date)
            t.column(Columns.comment)
            t.column(Columns.exp1)
            t.column(Columns.exp2)
            t.column(Columns.exp3)
            t.primaryKey(Columns.babyID, Columns.date)
        })
    }

    func insert(or: OnConflict = .fail) throws {
        try Database.conn.run(DailyRecord.table.insert(or: or,
                                                       Columns.babyID <- babyID,
                                                       Columns.date <- date,
                                                       Columns.comment <- comment
        ))
        created = true
    }

    class func get(babyID: Int, date: Date) throws -> DailyRecord? {
        try Database.conn.prepare(table.filter(
            Columns.babyID == babyID && Columns.date == date
        )).map(DailyRecord.init(row:)).first
    }

    class func get(babyID: Int, from: Date, to: Date) throws -> [DailyRecord] {
        try Database.conn.prepare(table
                                    .filter(Columns.babyID == babyID &&
                                                from...to ~= Columns.date)
                                    .order(Columns.date)
        ).map(DailyRecord.init(row:))
    }

    func save(_ keys: Keys...) throws {
        if created {
            try Database.conn.run(DailyRecord.table
                                    .filter(Columns.date == date &&
                                                Columns.babyID == babyID)
                                    .update(keys.map {
                                        switch $0 {
                                        case .comment:
                                            return Columns.comment <- comment
                                        case .date:
                                            return Columns.date <- date
                                        case .manNumber:
                                            return Columns.babyID <- babyID
                                        }
                                    })
            )
        } else {
            try insert()
        }
    }
}
