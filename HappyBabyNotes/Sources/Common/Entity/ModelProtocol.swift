//
//  AppModel.swift
//  HappyBabyNotes
//
//  Created by Azuma on 2019/04/06.
//  Copyright © 2019 Studio9. All rights reserved.
//

import Foundation
import SQLite

protocol ModelProtocol: AnyObject {
    static func select(completion: @escaping ([Self]) -> Void)
    func insert(completion: (Bool) -> Void)
    func update(completion: (Bool) -> Void)
}
