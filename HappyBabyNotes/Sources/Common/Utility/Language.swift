//
// Created by BadApple on 2019-05-20.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation

enum Language: Int {
    case japanese = 0
    case english = 1
}

extension Language {
    static var mostPreferred: Language {
        for language in Locale.preferredLanguages {
            if language.hasPrefix("ja") {
                return .japanese
            } else if language.hasPrefix("en") {
                return .english
            }
        }
        return .english
    }
}
