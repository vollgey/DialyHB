//
// Created by BadApple on 2019-05-20.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import UIKit
import SQLite

enum Theme: Int, CaseIterable {
    case white = 0
    case pink1 = 1
    case lightBlue = 2
    case orange = 3
    case black = 4
    case pink2 = 5
}

extension Theme {
    var color: UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .pink1:
            return UIColor.pink
        case .lightBlue:
            return UIColor.lightBlue
        case .orange:
            return UIColor.ocher
        case .black:
            return UIColor.lightBlack
        case .pink2:
            return UIColor.skin
        }
    }

    var text: String {
        switch self {
        case .white:
            return "白"
        case .pink1:
            return "ピンク"
        case .lightBlue:
            return "水色"
        case .orange:
            return "オレンジ"
        case .black:
            return "黒色"
        case .pink2:
            return "薄いピンク"
        }
    }
}

extension UIColor {
    convenience init(_ code: String) {
        var color: UInt32 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            b = CGFloat( color & 0x0000FF) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension UIColor {
    static let pink = UIColor("#FFCCE1")
    static let lightBlue = UIColor("#9BF9F5")
    static let ocher = UIColor("#FDCC00")
    static let lightBlack = UIColor("#999999")
    static let skin = UIColor("#FED4C0")
}
