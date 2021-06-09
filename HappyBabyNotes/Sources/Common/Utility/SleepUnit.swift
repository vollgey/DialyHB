//
// Created by BadApple on 2019-05-20.
// Copyright (c) 2019 Studio9. All rights reserved.
//

enum SleepUnit: Int, CaseIterable {
    case threeTypes = 0
    case sevenTypes = 1
    case thirteenTypes = 2
}

extension SleepUnit {
    var text: String {
        switch self {
        case .threeTypes:
            return "30分(3パターン)"

        case .sevenTypes:
            return "15分(7パターン)"

        case .thirteenTypes:
            return "15分(13パターン)"
        }
    }
}

//enum SleepUnitText: String{
//    case threeTypes = "30分（3パターン）"
//    case sevenTypes = "15分（7タイプ）"
//    case thirteenTypes = "15分（13パターン）"
//}
