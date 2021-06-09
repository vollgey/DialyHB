//
//  Milk.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

enum Milk: Int {
    case powder = 0
    case mother = 1
    case motherAndPowder = 2
    case food = 3
    case foodAndPowder = 4
    case foodAndMother = 5
}

extension Milk: NoteCellType {
    var string: String {
        switch self {
        case .powder:
            return "PowderMilk"
        case .mother:
            return "MotherMilk"
        case .motherAndPowder:
            return "MotherAndPowderMilk"
        case .food:
            return "Food"
        case .foodAndPowder:
            return "FoodAndPowderMilk"
        case .foodAndMother:
            return "FoodAndMotherMilk"
        }
    }
}

extension Optional where Wrapped == Milk {
    func next() -> Wrapped? {
        if let rawValue = self?.rawValue {
            return Wrapped(rawValue: rawValue + 1)
        } else {
            return Wrapped(rawValue: 0)
        }
    }
}
