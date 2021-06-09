//
//  DateCellType.swift
//  HappyBabyNotes
//
//  Created by BadApple on 2019/05/29.
//  Copyright © 2019 Studio9. All rights reserved.
//

import UIKit

protocol NoteCellType {
    var string: String { get }
    var path: String { get }
    var uiImageArray: [UIImage] { get }
}

extension NoteCellType {
    var path: String {
        self.string + ".png"
    }

    // アニメーション用のUIImageの配列を取得する
    var uiImageArray: [UIImage] {
        var uiImageArray: [UIImage] = []
        var i = 1
        while let uiImage = UIImage(named: "\(self.string)\(String(format: "%04d", i))") {
            uiImageArray.append(uiImage)
            i += 1
        }
        return uiImageArray
    }
}
