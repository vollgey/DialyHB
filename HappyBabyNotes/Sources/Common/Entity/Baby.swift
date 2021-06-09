//
//  Setting.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/02/13.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SQLite

struct Baby {
    static let table = Table("Settings")

    private(set) var id: Int
    var name: String
    var birthday: Date
    var theme: Theme

    enum Keys {
        case id
        case name
        case birthday
        case theme
    }

    private(set) var created: Bool

    enum Columns {
        static let id = Expression<Int>("ManNumber")//キー 1, 2, 3...
        static let name = Expression<String?>("Name")//名前
        static let birthday = Expression<Date?>("BirthDay")//誕生日 yyyyMMdd
        static let defMilkVol = Expression<String?>("DefMilkVol")//デフォルトのミルクの量(未使用)
        static let theme = Expression<String?>("Theme")//テーマ 1~6:色
        static let language = Expression<String?>("Lang")//言語 0:日本語, 1:英語 （CommonSettingsに移行）
        static let initDisplay = Expression<String?>("InitDisp")//起動時に表示する赤ちゃんのmanNumber（CommonSettingsに移行）
        static let is24HourClock = Expression<String?>("Exp1")//時刻表期 0:12時制 1:24時制 （使わない）(CommonSettingsに移行）
        static let sleepUnit = Expression<String?>("Exp2")//睡眠の単位 0:30分単位, 1:15分単位, 2:15分単位(13パターン) （CommonSettingsに移行）
        static let exp3 = Expression<String?>("Exp3")//未使用
    }

    init(id: Int, name: String, birthday: Date, theme: Theme) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.theme = theme

        created = false
    }

    init(row: Row) {
        self.id = row[Columns.id] - 1
        self.name = row[Columns.name] ?? ""
        self.birthday = row[Columns.birthday] ?? Date()
        self.theme = row[Columns.theme].flatMap(Int.init).flatMap {
            Theme(rawValue: $0 - 1)
        } ?? Theme.white

        created = true
    }

    static func createTable(ifNotExists: Bool = true) throws {
        try Database.conn.run(table.create(ifNotExists: ifNotExists) { t in
            t.column(Columns.id)
            t.column(Columns.name)
            t.column(Columns.birthday)
            t.column(Columns.defMilkVol)
            t.column(Columns.theme)
            t.column(Columns.language)
            t.column(Columns.initDisplay)
            t.column(Columns.is24HourClock)
            t.column(Columns.sleepUnit)
            t.column(Columns.exp3)
            t.primaryKey(Columns.id)
        })

        // デフォルト設定を挿入
        var b = Baby(id: 0, name: "Baby1", birthday: Date(), theme: .white)
        try b.insert(or: .ignore)
        b = Baby(id: 1, name: "Baby2", birthday: Date(), theme: .pink1)
        try b.insert(or: .ignore)
        b = Baby(id: 2, name: "Baby3", birthday: Date(), theme: .pink2)
        try b.insert(or: .ignore)
    }

    mutating func insert() throws {
        try Database.conn.run(Baby.table.insert(
            Columns.id <- (id + 1),
            Columns.name <- name,
            Columns.birthday <- birthday.date,
            Columns.theme <- String(theme.rawValue + 1)
        ))
        created = true
    }

    mutating func insert(or: OnConflict) throws {
        try Database.conn.run(Baby.table.insert(or: or,
                                                Columns.id <- (id + 1),
                                                Columns.name <- name,
                                                Columns.birthday <- birthday.date,
                                                Columns.theme <- String(theme.rawValue + 1)
        ))
        created = true
    }

    static func getAll() throws -> [Baby] {
        try Database.conn.prepare(table
                                    .order(Columns.id)
        ).map(Baby.init(row:))
    }

    static func getNextBabyID() throws -> Int {
        (
            //          try Database.conn.scalar(Baby.table.select(Columns.id.max)).map{$0 + 1}
            try Database.conn.scalar(Baby.table.select(Columns.id.max))
        ) ?? 0
    }

    static func get(id: Int) throws -> Baby? {
        try Database.conn.prepare(table
                                    .filter(Columns.id == id + 1)
        ).map(Baby.init(row:)).first
    }

    mutating func save(keys: Keys...) throws {
        if created {
            try Database.conn.run(Baby.table
                                    .filter(Columns.id == id + 1)
                                    .update(keys.map {
                                        switch $0 {
                                        case .id:
                                            return Columns.id <- (id + 1)
                                        case .name:
                                            return Columns.name <- name
                                        case .birthday:
                                            return Columns.birthday <- birthday
                                        case .theme:
                                            return Columns.theme <- String(theme.rawValue + 1)
                                        }
                                    })
            )
        } else {
            try insert()
        }
    }

    static func update(id: Int, name: String) throws {
        try Database.conn.run(Baby.table
                                .filter(Columns.id == id + 1)
                                .update(Columns.name <- name)
        )
    }

    static func update(id: Int, theme: Theme) throws {
        try Database.conn.run(Baby.table
                                .filter(Columns.id == id + 1)
                                .update(Columns.theme <- String(theme.rawValue + 1))
        )
    }

    static func update(id: Int, birthday: Date) throws {
        try Database.conn.run(Baby.table
                                .filter(Columns.id == id + 1)
                                .update(Columns.birthday <- birthday)
        )
    }
}
