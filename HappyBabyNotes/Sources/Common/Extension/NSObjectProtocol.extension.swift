//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        String(describing: self)
    }
}
