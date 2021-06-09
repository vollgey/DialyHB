//
//  Time.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

enum Sleep: Int {
    case before = 0
    case all = 1
    case after = 2
    case before15 = 3
    case before45 = 4
    case after15 = 5
    case after45 = 6
    case middle30 = 7
    case middle15 = 8
    case middle45 = 9
    case split15_30 = 10
    case split30_15 = 11
    case split15_15 = 12
}

extension Sleep: NoteCellType {
    var string: String {
        switch self {
        case .before:
            return "SleepBefore"
        case .all:
            return "SleepAll"
        case .after:
            return "SleepAfter"
        case .before15:
            return "SleepBefore15"
        case .before45:
            return "SleepBefore45"
        case .after15:
            return "SleepAfter15"
        case .after45:
            return "SleepAfter45"
        case .middle30:
            return "SleepMiddle30"
        case .middle15:
            return "SleepMiddle15"
        case .middle45:
            return "SleepMiddle45"
        case .split15_30:
            return "SleepSplit1530"
        case .split30_15:
            return "SleepSplit3015"
        case .split15_15:
            return "SleepSplit1515"
        }
    }
}

extension Optional where Wrapped == Sleep {
    func next() -> Wrapped? {
        if let rawValue = self?.rawValue {
            return Wrapped(rawValue: rawValue + 1)
        } else {
            return Wrapped(rawValue: 0)
        }
    }
}
