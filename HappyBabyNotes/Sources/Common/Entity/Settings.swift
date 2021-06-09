//
// Created by BadApple on 2019-05-20.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import SQLite

//import RealmSwift
//import RxRealm

struct Settings {
    static let table = Table("CommonSettings")

    var id: Int
    var language: Language
    var initialBabyID: Int
    var is24HClockNotation: Bool
    var sleepUnit: SleepUnit

    enum Keys {
        case id
        case language
        case initialBabyID
        case is24HClockNotation
        case sleepUnit
    }

    enum UpdatedKeys {
        case language(Language)
        case initialBabyID(Int)
        case is24HClockNotation(Bool)
        case sleepUnit(SleepUnit)
    }

    private(set) var created: Bool

    enum Columns {
        static let id = Expression<Int>("ID")//キー
        static let language = Expression<Int>("Language")//言語 0:日本語, 1:英語
        static let initialBabyID = Expression<Int>("InitialBabyID")//起動時に表示するBabyのid 0 1 2...
        static let is24HClockNotation = Expression<Bool>("ClockNotation")//時刻表期 false:12時制 true:24時制
        static let sleepUnit = Expression<Int>("SleepUnit")//睡眠の単位 0:30分単位, 1:15分単位, 2:15分単位(13パターン)
    }

    init(id: Int, language: Language, initialBabyID: Int, is24HClockNotation: Bool, sleepUnit: SleepUnit) {
        self.id = id
        self.language = language
        self.initialBabyID = initialBabyID
        self.is24HClockNotation = is24HClockNotation
        self.sleepUnit = sleepUnit

        created = false
    }

    init(row: Row) {
        self.id = row[Columns.id]
        self.language = Language(rawValue: row[Columns.language]) ?? Language.english
        self.initialBabyID = row[Columns.initialBabyID]
        self.is24HClockNotation = row[Columns.is24HClockNotation]
        self.sleepUnit = SleepUnit(rawValue: row[Columns.sleepUnit]) ?? SleepUnit.threeTypes

        created = true
    }

    static func createTable(ifNotExists: Bool = true) throws {
        try Database.conn.run(table.create(ifNotExists: ifNotExists) { t in
            t.column(Columns.id)
            t.column(Columns.language)
            t.column(Columns.initialBabyID)
            t.column(Columns.is24HClockNotation)
            t.column(Columns.sleepUnit)
            t.primaryKey(Columns.id)
        })

        // デフォルト設定を挿入
        var s = Settings(id: 0, language: .mostPreferred, initialBabyID: 0,
                         is24HClockNotation: false, sleepUnit: .threeTypes)
        try! s.insert(or: .ignore)
    }

    mutating func insert() throws {
        try Database.conn.run(Settings.table.insert(
            Columns.id <- id,
            Columns.language <- language.rawValue,
            Columns.initialBabyID <- initialBabyID,
            Columns.is24HClockNotation <- is24HClockNotation,
            Columns.sleepUnit <- sleepUnit.rawValue
        ))

        created = true
    }

    mutating func insert(or: OnConflict) throws {
        try Database.conn.run(Settings.table.insert(or: or,
                                                    Columns.id <- id,
                                                    Columns.language <- language.rawValue,
                                                    Columns.initialBabyID <- initialBabyID,
                                                    Columns.is24HClockNotation <- is24HClockNotation,
                                                    Columns.sleepUnit <- sleepUnit.rawValue
        ))

        created = true
    }

    mutating func save(updatedKeys: Keys...) throws {
        if created {
            try Database.conn.run(Settings.table
                                    .filter(Columns.id == id)
                                    .update(updatedKeys.map {
                                        switch $0 {
                                        case .id:
                                            return Columns.id <- id
                                        case .language:
                                            return Columns.language <- language.rawValue
                                        case .initialBabyID:
                                            return Columns.initialBabyID <- initialBabyID
                                        case .is24HClockNotation:
                                            return Columns.is24HClockNotation <- is24HClockNotation
                                        case .sleepUnit:
                                            return Columns.sleepUnit <- sleepUnit.rawValue
                                        }
                                    })
            )
        } else {
            try insert()
        }
    }

    static func update(updatedKeys: UpdatedKeys...) throws {
        try Database.conn.run(Settings.table
                                .filter(Columns.id == 0)
                                .update(updatedKeys.map {
                                    switch $0 {
                                    case .language(let language):
                                        return Columns.language <- language.rawValue
                                    case .initialBabyID(let initialBabyID):
                                        return Columns.initialBabyID <- initialBabyID
                                    case .is24HClockNotation(let is24HClockNotation):
                                        return Columns.is24HClockNotation <- is24HClockNotation
                                    case .sleepUnit(let sleepUnit):
                                        return Columns.sleepUnit <- sleepUnit.rawValue
                                    }
                                })
        )
    }

    static func get() throws -> Settings? {
        try Database.conn.prepare(table).map(Settings.init(row:)).first
    }

    static func update(sleepUnit: SleepUnit) throws {
        try Database.conn.run(Settings.table
                                .update(Columns.sleepUnit <- sleepUnit.rawValue)
        )
    }

    static func update(isOn: Bool) throws {
        try Database.conn.run(Settings.table
                                .update(Columns.is24HClockNotation <- isOn)
        )
    }
}
