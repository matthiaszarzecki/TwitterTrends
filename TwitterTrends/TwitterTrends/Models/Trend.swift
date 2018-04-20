//
//  TrendModel.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 09.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

struct Trend {
    let name: String
    let query: String
    let tweetVolume: Int
    let promotedContent: Bool
    let url: String
}
