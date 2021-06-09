//
// Created by BadApple on 2019-08-07.
// Copyright (c) 2019 Studio9. All rights reserved.
//

struct Value<Base> {
    let base: Base
}

protocol ValueCompatible {
    var value: Value<Self> { get }
}

extension ValueCompatible {
    var value: Value<Self> {
        Value(base: self)
    }
}
