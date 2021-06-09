//
// Created by BadApple on 2019-05-13.
// Copyright (c) 2019 Studio9. All rights reserved.
//

enum Diaper: Int {
    case booBoo = 0
    case titi = 1
    case booBooAndTiti = 2
}

extension Diaper: NoteCellType {
    var string: String {
        switch self {
        case .booBoo:
            return "BooBoo"
        case .titi:
            return "Titi"
        case .booBooAndTiti:
            return "BooBooAndTiti"
        }
    }
}

extension Optional where Wrapped == Diaper {
    func next() -> Wrapped? {
        if let rawValue = self?.rawValue {
            return Wrapped(rawValue: rawValue + 1)
        } else {
            return Wrapped(rawValue: 0)
        }
    }
}
