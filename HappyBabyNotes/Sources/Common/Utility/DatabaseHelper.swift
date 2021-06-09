//
//  DBHelper.swift
//  HappyBabyNotes
//
//  Created by さとうあずま on 2019/04/27.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation

struct DatabaseHelper {
    static func getFilePath() -> String {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
        let filePath = dir.appendingPathComponent("HappyBaby.db")
        return filePath.absoluteString
    }
}
