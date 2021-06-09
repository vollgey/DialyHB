//
//  CommentAndDetails.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

import SwiftDate

public struct CommentAndDetails {
    let date: DateInRegion
    let comment: DailyRecord?
    let details: [HourlyRecord]
}
